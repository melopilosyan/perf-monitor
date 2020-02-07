require 'rails_helper'

RSpec.describe 'Page Speed Insights' do
  include ActiveJob::TestHelper

  def expect_response(expected_response)
    expect(response.body).to be_eql expected_response
  end

  describe 'POST requests' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
    let :params do
      {
        url: 'https://rubylabs.am',
        max_ttfp: 800, max_ttfb: 800,
        max_tti: 800, max_speed_index: 800
      }
    end

    def post_data(params)
      post '/tests', params: params.to_json, headers: headers
    end

    context 'Success responses' do
      # have_been_enqueued.at doesn't work because there is milliseconds
      # difference between job's real schedule and given time to match
      def expected_enqueued_job(job, at:)
        expect(
          ActiveJob::Base.queue_adapter.enqueued_jobs.find do |job_info|
            job_info[:job] == job && job_info[:at].to_i == at.to_i
          end
        ).to be_truthy
      end

      def successful_post(params)
        expect {
          expect { post_data params }.to change{ TestCriterium.count }.by(1)
        }.to change{ TestResult.count }.by(1)
      end

      it 'runs test with no rerun' do
        VCR.use_cassette 'valid-criteria-no-rerun' do
          successful_post params
        end

        expect_response '{"passed":true,"ttfb":163,"ttfp":544,"tti":544,"speed_index":544}'
        expect(RerunTestJob).not_to have_been_enqueued
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end

      it 'runs test with rerun in 2 minutes' do
        VCR.use_cassette 'valid-criteria-with-rerun' do
          # assert_enqueued_with job: RerunTestJob, at: Time.now + 2.minutes do
          successful_post params.merge max_tti: 789, retry_in_mins: 2

          expected_enqueued_job RerunTestJob, at: 2.minutes.from_now
        end

        expect_response '{"passed":true,"ttfb":131,"ttfp":663,"tti":663,"speed_index":541}'
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end

      it 'uses existing TestCriterium object' do
        VCR.use_cassette 'valid-criteria-no-rerun' do
          expect {
            expect { post_data params }.to change { TestResult.count }.by(1)
          }.to_not change { TestCriterium.count }
        end

        expect_response '{"passed":true,"ttfb":163,"ttfp":544,"tti":544,"speed_index":544}'
        expect(RerunTestJob).not_to have_been_enqueued
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end

      # I know it's a job test, but lets do it here
      it 'performs RerunTestJob and schedules next run' do
        VCR.use_cassette 'rerun-test-job' do
          expect {
            RerunTestJob.perform_now TestCriterium.last.id
          }.to change { TestResult.count }.by(1)
        end

        expected_enqueued_job RerunTestJob, at: 2.minutes.from_now
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end

      it 'sends notify_not_passed email' do
        VCR.use_cassette 'notify_not_passed' do
          successful_post params.merge max_tti: 200
        end

        expect(ActionMailer::DeliveryJob).to have_been_enqueued
          .with('TestResultMailer', 'notify_not_passed', 'deliver_now', TestResult.last.id)
        expect_response '{"passed":false,"ttfb":148,"ttfp":658,"tti":673,"speed_index":658}'
      end
    end

    context 'Failure responses' do
      def failure_post(params)
        expect {
          expect { post_data params }.to_not change { TestResult.count }
        }.to_not change { TestCriterium.count }
      end

      it 'responds with error message if required parameter is missing' do
        VCR.use_cassette 'required-parameter-missing' do
          failure_post params.tap { |p| p.delete :max_tti }
        end

        expect_response %q({"error":"Max tti can't be blank. Max tti is not a number"})
        expect(RerunTestJob).not_to have_been_enqueued
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end

      it 'responds with error message if given URL is invalid' do
        VCR.use_cassette 'invalid-url' do
          failure_post params.merge url: 'invalid', retry_in_mins: 2
        end

        expect_response %q({"error":"Invalid value 'invalid'. Values must match the following regular expression: '(?i)(url:|origin:)?http(s)?://.*'"})
        expect(RerunTestJob).not_to have_been_enqueued
        expect(ActionMailer::DeliveryJob).not_to have_been_enqueued
      end
    end
  end

  describe 'GET requests' do
    let(:params) { { url: 'https://rubylabs.am' } }
    let(:entry_attrs) do
      %w(passed ttfb ttfp tti speed_index url max_ttfb
         max_ttfp max_tti max_speed_index created_at)
    end

    it 'lists all test results for given URL' do
      get '/tests', params: params

      entries = JSON.parse response.body
      expect(entries.size).to eql(5)
      expect(entries.first.keys).to eql(entry_attrs)
    end

    it 'renders the last text result for the URL' do
      get '/tests/last', params: params

      entry = JSON.parse response.body
      expect(entry.keys).to eql(entry_attrs)
    end
  end

  after(:all) { TestCriterium.destroy_all }
end

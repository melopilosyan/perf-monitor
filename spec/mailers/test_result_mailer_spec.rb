require 'rails_helper'

RSpec.describe TestResultMailer do
  fixtures :test_results, :test_criteria

  describe 'notify_not_passed' do
    let(:result) { test_results :first }
    let(:mail) { TestResultMailer.notify_not_passed(result.id).deliver_now }

    it 'delivers with correct metadata' do
      expect(mail.from).to eql([MAILER_DEFAULT_FROM])
      expect(mail.to).to eql([RECEIVER_EMAILS])
      expect(mail.subject).to eql("Performance test failed for #{result.criterium.url}")
    end

    it 'includes real values' do
      PageSpeedApi::ATTRS_MAP.keys
        .map { |attr| /#{attr}.*#{result[attr]}/ }
        .each do |matcher|
          expect(mail.body.encoded).to match(matcher)
        end
    end

    it 'includes maximum criteria specified' do
      TestCriterium::REQUIRED_COLUMNS.keys
        .map { |attr| /#{attr}.*#{result.send attr}/ }
        .each do |matcher|
          expect(mail.body.encoded).to match(matcher)
        end
    end

    it 'includes test date, but not ERROR or scheduled(this result does not have both)' do
      expect(mail.body.encoded).to include(result.created_at.to_s)
      expect(mail.body.encoded).to_not include('ERROR')
      expect(mail.body.encoded).to_not include('Scheduled to rerun at')
    end

    context 'error message and schedule' do
      let(:result) { test_results :error }
      let(:mail) { TestResultMailer.notify_not_passed(result.id).deliver_now }

      it 'includes error message and schedule date' do
        expect(mail.body.encoded).to include(result.error)

        scheduled_at = result.criterium.rerun_in_mins.minutes.from_now
        expect(mail.body.encoded).to include("Scheduled to rerun at #{scheduled_at}")
      end
    end
  end
end

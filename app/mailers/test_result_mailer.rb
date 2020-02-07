class TestResultMailer < ApplicationMailer
  RECEIVER_EMAILS = ENV.fetch('RECEIVER_EMAILS', nil)

  def notify_not_passed(test_result_id)
    @test_result = TestResult.find test_result_id
    return mail.perform_deliveries = false unless RECEIVER_EMAILS.present?

    mail to: RECEIVER_EMAILS,
      subject: "Performance test failed for #{@test_result.criterium.url}"
  end
end

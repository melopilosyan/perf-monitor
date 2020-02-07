class TestResultMailer < ApplicationMailer
  RECEIVER_EMAIL = ENV.fetch('RECEIVER_MAIL', nil)

  def notify_failure(test_result_id)
    return mail.perform_deliveries = false unless RECEIVER_EMAIL.present?
    @test_result = TestResult.find test_result_id

    mail to: RECEIVER_EMAIL,
      subject: "Performance test failed for #{@test_result.criterium.url}"
  end
end

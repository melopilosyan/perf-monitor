# Preview all emails at http://localhost:3000/rails/mailers/test_result_mailer/
#
class TestResultMailerPreview < ActionMailer::Preview
  def notify_failure
    TestResultMailer.notify_failure TestResult.last.id
  end
end
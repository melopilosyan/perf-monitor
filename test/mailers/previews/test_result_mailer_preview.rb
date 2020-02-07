# Preview all emails at http://localhost:3000/rails/mailers/test_result_mailer/

class TestResultMailerPreview < ActionMailer::Preview
  def notify_not_passed
    TestResultMailer.notify_not_passed TestResult.last.id
  end
end

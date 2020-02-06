class RerunTestJob < ApplicationJob

  def perform(test_criterium_id)
    criterium = TestCriterium.find_by id: test_criterium_id
    return unless criterium

    criterium.rerun_test

    return unless criterium.retry_in_mins.positive?
    retry_job wait: criterium.retry_in_mins.minutes
  end
end

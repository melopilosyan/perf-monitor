class RerunTestJob < ApplicationJob
  def self.schedule_for(criterium)
    return unless criterium.retry_in_mins.positive?

    set(wait: criterium.retry_in_mins.minutes).perform_later criterium.id
  end

  def perform(test_criterium_id)
    criterium = TestCriterium.find_by id: test_criterium_id
    return unless criterium

    criterium.rerun_test

    self.class.schedule_for criterium
  end
end

# == Schema Information
#
# Table name: test_results
#
#  id                :integer          not null, primary key
#  test_criterium_id :integer
#  ttfb              :integer
#  tti               :integer
#  speed_index       :integer
#  passed            :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ttfp              :integer
#  error             :string
#
# Indexes
#
#  index_test_results_on_test_criterium_id  (test_criterium_id)
#

class TestResult < ApplicationRecord
  belongs_to :criterium, inverse_of: :results,
    class_name: 'TestCriterium', foreign_key: :test_criterium_id

  delegate *TestCriterium::REQUIRED_COLUMNS.keys, to: :criterium

  before_save :set_passed_state

  after_create do
    TestResultMailer.notify_failure(id).deliver_later unless passed
  end

  scope :by_url, -> url do
    joins(:criterium).where test_criteria: { url: url }
  end

  def set_passed_state
    self.passed = ttfb <= max_ttfb && ttfp <= max_ttfp &&
      tti <= max_tti && speed_index <= max_speed_index rescue false
  end
end

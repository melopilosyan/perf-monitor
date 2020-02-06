# == Schema Information
#
# Table name: test_criteria
#
#  id              :integer          not null, primary key
#  url             :string
#  max_ttfb        :integer
#  max_tti         :integer
#  max_speed_index :integer
#  max_ttfp        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TestCriterium < ApplicationRecord
  has_many :results, inverse_of: :criterium, class_name: 'TestResult'
  accepts_nested_attributes_for :results

  validates_presence_of :url
  validates_numericality_of :max_tti, :max_ttfp,
                            :max_ttfb, :max_speed_index, greater_than: 0

  after_validation :run_test

  def rerun_test
    results.create PageSpeedApi.insights_for(url)
  end

  private

  def run_test
    data = PageSpeedApi.insights_for url
    return errors.add :base, data[:error] if data[:error]

    self.results_attributes = [data]
  end
end

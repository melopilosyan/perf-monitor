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

  after_validation :set_results_attributes

  def set_results_attributes
    result = PageSpeedApi.process url
    return process_error result if result['error']

    self.results_attributes =
      [TestResult.parse_page_speed_info(result['lighthouseResult']['audits'])]
  end

  def process_error(result)
    res_errors = result['error']['errors'].map { |err| err['message'] }
    errors.add :base, res_errors.join('. ')
  end
end

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
  validates :max_tti, :max_ttfp, :max_ttfb, :max_speed_index,
            presence: true, numericality: { greater_than: 0 }

  after_validation :run_test_first_time

  def self.run_test(params)
    all_attrs = new.attributes.symbolize_keys.merge params
    criterium = find_or_initialize_by all_attrs
    return criterium.rerun_test if criterium.persisted?

    criterium.save
    criterium.results.last
  end

  def rerun_test
    results.create PageSpeedApi.insights_for(url)
  end

  def run_test_first_time
    data = PageSpeedApi.insights_for url

    errors.add :base, data[:error] if data[:error]
    data[:error] = errors.full_messages.join('. ').presence if errors.any?

    results.build data
  end
end

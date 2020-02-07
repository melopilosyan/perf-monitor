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
#  rerun_in_mins   :integer          default(0)
#

class TestCriterium < ApplicationRecord
  REQUIRED_COLUMNS = {
    max_ttfp: nil, max_ttfb: nil, max_tti: nil, max_speed_index: nil
  }.freeze

  has_many :results, inverse_of: :criterium,
    class_name: 'TestResult', dependent: :destroy

  validates_presence_of :url
  validates *REQUIRED_COLUMNS.keys, presence: true,
    numericality: { greater_than: 0 }

  after_validation :run_test_first_time
  after_create { RerunTestJob.schedule_for self }

  def self.run_test(params)
    all_attrs = REQUIRED_COLUMNS.merge params.to_h.symbolize_keys
    criterium = find_or_initialize_by all_attrs
    return criterium.rerun_test if criterium.persisted?

    criterium.save
    criterium.results.last
  end

  def rerun_test
    results.create PageSpeedApi.insights_for(url)
  end

  def run_test_first_time
    return if persisted?

    data = PageSpeedApi.insights_for url

    errors.add :base, data[:error] if data[:error]
    data[:error] = errors.full_messages.join('. ').presence if errors.any?

    results.build data
  end
end

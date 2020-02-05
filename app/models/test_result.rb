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
#
# Indexes
#
#  index_test_results_on_test_criterium_id  (test_criterium_id)
#

class TestResult < ApplicationRecord
  ATTRS_MAP = {
    ttfp: 'first-meaningful-paint',
    ttfb: 'time-to-first-byte',
    tti: 'interactive',
    speed_index: 'speed-index'
  }.freeze

  belongs_to :criterium, inverse_of: :results,
             class_name: 'TestCriterium', foreign_key: :test_criterium_id

  def self.parse_page_speed_info(audits)
    ATTRS_MAP.map {|k, v| [k, audits[v]['numericValue']] }.to_h
  end
end

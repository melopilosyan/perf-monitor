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
#
# Indexes
#
#  index_test_results_on_test_criterium_id  (test_criterium_id)
#

require 'test_helper'

class TestResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

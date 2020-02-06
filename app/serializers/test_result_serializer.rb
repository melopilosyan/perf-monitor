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

class TestResultSerializer < ActiveModel::Serializer
  attributes :ttfb, :ttfp, :tti, :speed_index, :passed
  with_options if: -> { include_criteria } do
    attribute :url
    attribute :max_ttfb
    attribute :max_ttfp
    attribute :max_tti
    attribute :max_speed_index
    attribute :created_at
  end

  def url
    object.criterium.url
  end
end

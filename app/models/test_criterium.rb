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
  has_many :test_results, inverse_of: :test_criterium
end

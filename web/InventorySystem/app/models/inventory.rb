# == Schema Information
#
# Table name: inventories
#
#  id                :integer          not null, primary key
#  department        :string(255)      not null
#  position          :string(255)      not null
#  part              :string(255)      not null
#  part_type         :string(255)      not null
#  check_qty         :float(24)
#  check_user        :string(255)
#  check_time        :datetime
#  random_check_qty  :float(24)
#  random_check_user :string(255)
#  random_check_time :datetime
#  is_random_check   :boolean          default(FALSE)
#  ios_created_id    :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Inventory < ActiveRecord::Base
  validates :department, :position, :part, :part_type, presence: true
  validates :position, :part, uniqueness: true
  
  self.per_page = 50
  
  def self.search(search)
    if search
      where("part LIKE ?", "%#{search}%")
    else
      fin(:all)
    end
  end
end

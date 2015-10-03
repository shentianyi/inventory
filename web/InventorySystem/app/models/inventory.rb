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
  
  scope :check, -> { where("check_qty != '' or check_qty is not null")}
  
  self.per_page = 50
  
  def self.search(search)
    if search
      where("part LIKE ?", "%#{search}%")
    else
      fin(:all)
    end
  end
  
  def self.search_by_condition(department, position_begin, position_end, part, ios_created_id, is_random_check)
    inventories = Inventory
    condition = {}
    condition["department"] = department if department.present?
    condition["position"] = position_begin...position_end if position_begin.present? && position_end.present?
    # condition["ios_created_id"] = ios_created_id if ios_created_id.present?
    condition["is_random_check"] = is_random_check
    
    # condition["part"] =~ /part/ if part.present?
    inventories = inventories.where(condition)
    inventories = inventories.where("part like '%#{part}%' ") if part.present?
    if ios_created_id == '1'
      inventories = inventories.where("ios_created_id  != ''") 
    else 
      inventories = inventories.where("ios_created_id = ''")
    end 
    
    inventories
  end
end

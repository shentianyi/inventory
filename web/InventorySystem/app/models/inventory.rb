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
  validates :part, uniqueness: { scope: [:position,:department]}
  
  scope :check, -> { where("check_qty != '' or check_qty is not null")}
  scope :random_check, -> {where("is_random_check is true")}
  scope :random_check_not, -> { where("is_random_check is true and random_check_qty is null")}
  scope :random_check_completed, -> { where("is_random_check is true and random_check_qty != ''")}
  scope :position_client, -> { where("ios_created_id != ''")}
  scope :position_unclient, -> { where("ios_created_id = '' or ios_created_id is null")}
  self.per_page = 50
  # default.scope
  default_scope { order('id DESC') }
  def self.search(search)
    if search
      where("part LIKE ?", "%#{search}%")
    else
      fin(:all)
    end
  end
  
  def self.check_for_search(search)
    # puts "======testing"
    where("position=?", search)
  end
  
  def self.search_by_condition(department, position_begin, position_end, part, ios_created_id, is_random_check,params={})
    inventories = Inventory
    condition = {}
    condition["department"] = department if department.present?
    condition[:check_user]=params[:check_user] if params[:check_user].present?
    condition[:random_check_user]=params[:random_check_user] if params[:random_check_user].present?
    # condition["position"] = position_begin...position_end if position_begin.present? && position_end.present?    
    # condition["ios_created_id"] = ios_created_id if ios_created_id.present?
    condition["is_random_check"] = is_random_check if is_random_check.present?
    # condition["part"] =~ /part/ if part.present?
    inventories = inventories.where(condition)
    inventories = inventories.where("part like '%#{part}%' ") if part.present?
    if ios_created_id.present?
      if ios_created_id == '1'
        inventories = inventories.where("ios_created_id  != ''") 
      else 
        inventories = inventories.where("ios_created_id = '' ")
      end
    end 
    inventories = inventories.where("(position between '#{position_begin}' and '#{position_end}') or position like '%#{position_begin}%' or position like '%#{position_end}%' ") if position_begin.present? & position_end.present?
    # inventories = inventories.where("position like '%#{position_end}%' ") if position_end.present?
    inventories
  end
  
  def self.create_random_data
    
    counter = 1
    samples = []
    areas = []
    inventories = Inventory.all
    inventories.each do |inventory|
      inventory.update(random_check_qty: '', random_check_user: '', random_check_time: '', is_random_check: false)
      areas << inventory
      if counter == 10
        counter = 1
        areas.each { |x| puts "the position is #{x.position}"}
        samples = areas.shuffle.sample(3)
        samples.each {|x| x.update!(is_random_check: true)}
        samples.clear
        areas.clear
      end
      counter += 1
    end
  end

  def is_random_check_display
   self.is_random_check ? '是' : '否'
  end
end

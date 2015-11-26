# == Schema Information
#
# Table name: inventories
#
#  id                :integer          not null, primary key
#  department        :string(255)      not null
#  position          :string(255)      not null
#  part_nr              :string(255)      not null
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
  validates :sn, :department, :position, :part_nr, presence: true
  validates :part_nr, uniqueness: {scope: [:position, :department], message: '库位+部门+零件 必须唯一'}
  validates :sn, uniqueness: {message: '序列号 必须唯一'}

  # belongs_to :part, foreign_key: :part_nr, primary_key: :nr

  # scope :check, -> { where("check_qty != '' or check_qty is not null") }
  # scope :random_check, -> { where("is_random_check is true") }
  # scope :random_check_not, -> { where("is_random_check is true and random_check_qty is null") }
  # scope :random_check_completed, -> { where("is_random_check is true and random_check_qty != ''") }
  # scope :position_client, -> { where("ios_created_id != ''") }
  # scope :position_unclient, -> { where("ios_created_id = '' or ios_created_id is null") }

  scope :check, -> { where("check_qty != '' or check_qty is not null") }
  scope :random_check, -> { where("is_random_check is true") }
  scope :random_check_not, -> { where("is_random_check is true and random_check_qty is null") }
  scope :random_check_completed, -> { where("is_random_check is true and random_check_qty is not null") }
  scope :position_client, -> { where("ios_created_id is not null") }
  scope :position_unclient, -> { where("ios_created_id = '' or ios_created_id is null") }

  # def self.full_query
  #   joins(:part).select('parts.unit as part_unit,parts.type as part_type,inventories.*')
  # end

  self.per_page = 50
  default_scope { order('sn asc') }

  # 配置
  # has_settings do |s|
  #   s.key :random, defaults: {percent: 30}
  #   s.key :prefix, defaults: {part: 'P'}
  # end

  # alias :part_id :part_nr

  def self.search(search)
    if search
      where("part_nr LIKE ?", "%#{search}%")
    else
      find(:all)
    end
  end

  def self.check_for_search(search)
    # puts "======testing"
    where("position=?", search)
  end

  def self.search_by_condition(department, position_begin, position_end, part_nr, ios_created_id, is_random_check, params={})
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
    inventories = inventories.where("part_nr like '%#{part_nr}%' ") if part_nr.present?
    if ios_created_id.present?
      if ios_created_id == '1'
        inventories = inventories.where("ios_created_id  != ''")
      else
        inventories = inventories.where("ios_created_id = '' ")
      end
    end
    inventories = inventories.where("(position between '#{position_begin}' and '#{position_end}') or position like '%#{position_begin}%' or position like '%#{position_end}%' ") if position_begin.present? & position_end.present?
    # inventories = inventories.where("position like '%#{position_end}%' ") if position_end.present?
  inventories=inventories.where(sn:params[:sn_begin]..params[:sn_end]) if params[:sn_begin].present? && params[:sn_end].present?
	inventories
  end

  def self.create_random_data
    Inventory.update_all(random_check_qty: nil, random_check_user: nil, random_check_time: nil, is_random_check: false)

    self.uniq.pluck(:department).each do |deparment|
      ids= self.where(department: deparment).all.pluck(:id)
      # puts "#{ids}---------"
      sample_count= (ids.count* Setting.random_percent_value).round
      # puts "###############{ids.count}#####{Setting.random_percent_value}#######{sample_count}"
      self.where(id: ids.sample(sample_count)).update_all(is_random_check: true)
    end
    # counter = 1
    # samples = []
    # areas = []
    # inventories = Inventory.all
    # inventories.each do |inventory|
    #   inventory.update(random_check_qty: '', random_check_user: '', random_check_time: '', is_random_check: false)
    #   areas << inventory
    #   if counter == 10
    #     counter = 1
    #     areas.each { |x| puts "the position is #{x.position}" }
    #     samples = areas.shuffle.sample(3)
    #     samples.each { |x| x.update!(is_random_check: true) }
    #     samples.clear
    #     areas.clear
    #   end
    #   counter += 1
    # end
  end


  def is_random_check_display
    self.is_random_check ? '是' : '否'
  end

  def check_time_display
    self.check_time.nil? ? nil : self.check_time.strftime("%Y-%m-%d %H:%M:%S")
  end

  def random_check_time_display
    self.random_check_time.nil? ? nil : self.random_check_time.strftime("%Y-%m-%d %H:%M:%S")
  end
end

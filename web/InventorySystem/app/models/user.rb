# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nr         :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :name, :nr, :role, presence: true
  validates_uniqueness_of :nr
  self.per_page = 50

  ROLES=%w(盘点员 组长 其他)

  def self.auth nr
    user = User.find_by_nr(nr)
    user
  end

  def self.search(search)
    if search
      where("name LIKE ? or nr Like ? or role like ?", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      find(:all)
    end
  end

  def self.validate_role(role)
    ROLES.include? role
  end
end

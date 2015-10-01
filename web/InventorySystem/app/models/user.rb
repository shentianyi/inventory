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
  validates :name, presence: true
  validates :nr, presence: true
  validates_uniqueness_of :nr
  self.per_page = 50
  
  def self.search(search)
    if search
      where("name LIKE ?", "%#{search}%")
    else
      fin(:all)
    end
  end
end

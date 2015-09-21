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

class User < ActiveRecord::Base
  validates :name, presence: true
  validates :nr, presence: true
  validates_uniqueness_of :nr
end

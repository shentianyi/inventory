class Part < ActiveRecord::Base
  self.inheritance_column=:_type_disabled
  validates :nr, presence: true, uniqueness: {message: '零件号必须唯一'}
  validates :unit, presence: {message: '单位不可空'}
  validates :type, presence: {message: '类型不可空'}

  # has_many :inventories, foreign_key: :part_nr, primary_key: :nr

  self.per_page = 50

  scoped_search on: [:nr, :unit, :type]

  def nr_prefix
    "#{Setting.part_prefix}#{self.nr}"
  end
end

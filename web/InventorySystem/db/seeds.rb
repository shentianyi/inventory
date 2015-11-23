# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# (1200..1500).each do |n|
#   User.create(nr: n, name:"张三#{n}")
# end
#
#
# (1..99).each do |i|
#
#   if i<10
#     key = "000#{i}"
#   else
#     key = "00#{i}"
#   end
#   Inventory.create(department: "后勤1", position: key, part:key, part_type:"type1" )
# end
#
# (100..200).each do |j|
#
#   key2= "0#{j}"
#   Inventory.create(department: "后勤2", position: key2 , part: key2, part_type:"type2" )
# end

unless Setting.where(code: 'random_percent').first
  Setting.create(name: '抽盘比例(百分比)', value: '30', code: 'random_percent')
end

unless Setting.where(code: 'part_prefix').first
  Setting.create(name: '零件标签前缀', value: 'P', code: 'part_prefix')
end
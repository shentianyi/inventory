file=InventoryFile.new()

data={inventories: []}

Inventory.all.each do |i|
  data[:inventories]<<{
      id: i.id,
      department: i.department,
      position: i.position,
      part_nr: i.part_nr,
      check_qty: i.check_qty,
      check_user: i.check_user,
      check_time: i.check_time
  }
end

File.open('uploadfiles/data/data.json', 'w+') do |f|
  f.write(data.to_s)
  file.path = f
end

file.save

#
#
#
# |           | int(11)      | NO   | PRI | NULL    | auto_increment |
# |         | varchar(255) | NO   |     | NULL    |                |
# |           | varchar(255) | NO   | MUL | NULL    |                |
# |            | varchar(255) | NO   | MUL | NULL    |                |
# |          | float        | YES  |     | NULL    |                |
# |         | varchar(255) | YES  |     | NULL    |                |
# |         | datetime     | YES  |     | NULL    |                |
# | random_check_qty  | float        | YES  |     | NULL    |                |
# | random_check_user | varchar(255) | YES  |     | NULL    |                |
# | random_check_time | datetime     | YES  |     | NULL    |                |
# | is_random_check   | tinyint(1)   | YES  |     | 0       |                |
# | ios_created_id    | varchar(255) | YES  |     | NULL    |                |
# | created_at        | datetime     | NO   |     | NULL    |                |
# | updated_at        | datetime     | NO   |     | NULL    |                |
# | sn                | int(11)      | YES  |     | NULL    |                |
# | part_unit         | varchar(255) | YES  |     | NULL    |                |
# | part_type         | varchar(255) | YES  |     | NULL    |                |
# | wire_nr           | varchar(255) | YES  |     | NULL    |                |
# | process_nr
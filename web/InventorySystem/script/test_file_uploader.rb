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
      check_time: i.check_time,
      random_check_qty: i.random_check_qty,
      random_check_user: i.random_check_user,
      random_check_time: i.random_check_time,
      is_random_check: i.is_random_check,
      ios_created_id: i.ios_created_id,
      sn: i.sn,
      part_unit: i.part_unit,
      part_type: i.part_type,
      wire_nr: i.wire_nr,
      process_nr: i.process_nr
  }
end

File.open('uploadfiles/data/data.json', 'w+') do |f|
  f.write(data.to_s)
  file.path = f
end

file.save
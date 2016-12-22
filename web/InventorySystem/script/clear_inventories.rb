Inventory.transaction do
  Inventory.update_all(check_qty: nil, check_user: nil, check_time: nil, random_check_qty: nil, random_check_user: nil, random_check_time: nil, is_random_check: false, ios_created_id: nil)
end
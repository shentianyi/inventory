json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :department, :position, :part, :part_type, :check_qty, :check_user, :check_time, :random_check_qty, :random_check_user, :random_check_time, :is_random_check, :ios_created_id
  json.url inventory_url(inventory, format: :json)
end
json.array!(@inventory_files) do |inventory_file|
  json.extract! inventory_file, :id, :name, :path, :size
  json.url inventory_file_url(inventory_file, format: :json)
end

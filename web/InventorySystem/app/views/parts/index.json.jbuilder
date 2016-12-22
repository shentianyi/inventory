json.array!(@parts) do |part|
  json.extract! part, :id, :nr, :type, :unit
  json.url part_url(part, format: :json)
end

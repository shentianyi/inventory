module V1
  class InventoryApi < Grape::API
    namespace :inventory do
      format :json
      
      desc "List all Inventories"
      get do
        inventories = Inventory.all
        {result: 1, content: inventories}
      end
      
      
    end
  end
end
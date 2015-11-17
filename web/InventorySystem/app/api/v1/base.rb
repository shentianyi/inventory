#encoding: utf-8

module V1
  class Base < Grape::API
    version 'v1', :using => :path
    mount V1::InventoryApi
    mount V1::UserApi
  end
end
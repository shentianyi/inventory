require 'test_helper'

class InventoriesControllerTest < ActionController::TestCase
  setup do
    @inventory = inventories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory" do
    assert_difference('Inventory.count') do
      post :create, inventory: { check_qty: @inventory.check_qty, check_time: @inventory.check_time, check_user: @inventory.check_user, department: @inventory.department, ios_created_id: @inventory.ios_created_id, is_random_check: @inventory.is_random_check, part: @inventory.part, part_type: @inventory.part_type, position: @inventory.position, random_check_qty: @inventory.random_check_qty, random_check_time: @inventory.random_check_time, random_check_user: @inventory.random_check_user }
    end

    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should show inventory" do
    get :show, id: @inventory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inventory
    assert_response :success
  end

  test "should update inventory" do
    patch :update, id: @inventory, inventory: { check_qty: @inventory.check_qty, check_time: @inventory.check_time, check_user: @inventory.check_user, department: @inventory.department, ios_created_id: @inventory.ios_created_id, is_random_check: @inventory.is_random_check, part: @inventory.part, part_type: @inventory.part_type, position: @inventory.position, random_check_qty: @inventory.random_check_qty, random_check_time: @inventory.random_check_time, random_check_user: @inventory.random_check_user }
    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should destroy inventory" do
    assert_difference('Inventory.count', -1) do
      delete :destroy, id: @inventory
    end

    assert_redirected_to inventories_path
  end
end

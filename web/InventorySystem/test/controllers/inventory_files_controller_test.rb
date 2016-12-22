require 'test_helper'

class InventoryFilesControllerTest < ActionController::TestCase
  setup do
    @inventory_file = inventory_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventory_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory_file" do
    assert_difference('InventoryFile.count') do
      post :create, inventory_file: { name: @inventory_file.name, path: @inventory_file.path, size: @inventory_file.size }
    end

    assert_redirected_to inventory_file_path(assigns(:inventory_file))
  end

  test "should show inventory_file" do
    get :show, id: @inventory_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inventory_file
    assert_response :success
  end

  test "should update inventory_file" do
    patch :update, id: @inventory_file, inventory_file: { name: @inventory_file.name, path: @inventory_file.path, size: @inventory_file.size }
    assert_redirected_to inventory_file_path(assigns(:inventory_file))
  end

  test "should destroy inventory_file" do
    assert_difference('InventoryFile.count', -1) do
      delete :destroy, id: @inventory_file
    end

    assert_redirected_to inventory_files_path
  end
end

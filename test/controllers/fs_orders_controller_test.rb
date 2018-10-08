require 'test_helper'

class FsOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fs_order = fs_orders(:one)
  end

  test "should get index" do
    get fs_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_fs_order_url
    assert_response :success
  end

  test "should create fs_order" do
    assert_difference('FsOrder.count') do
      post fs_orders_url, params: { fs_order: { customer: @fs_order.customer, date_required: @fs_order.date_required, partcode: @fs_order.partcode, qty: @fs_order.qty, shipto: @fs_order.shipto } }
    end

    assert_redirected_to fs_order_url(FsOrder.last)
  end

  test "should show fs_order" do
    get fs_order_url(@fs_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_fs_order_url(@fs_order)
    assert_response :success
  end

  test "should update fs_order" do
    patch fs_order_url(@fs_order), params: { fs_order: { customer: @fs_order.customer, date_required: @fs_order.date_required, partcode: @fs_order.partcode, qty: @fs_order.qty, shipto: @fs_order.shipto } }
    assert_redirected_to fs_order_url(@fs_order)
  end

  test "should destroy fs_order" do
    assert_difference('FsOrder.count', -1) do
      delete fs_order_url(@fs_order)
    end

    assert_redirected_to fs_orders_url
  end
end

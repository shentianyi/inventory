class DashboardController < ApplicationController
  def index
    @check_qty_progress = Inventory.where("check_qty != ''").group('year(check_time)').group('month(check_time)').group('day(check_time)').count(:id)
	  @check_qty_progress['未全盘'] = Inventory.where("check_qty is null").count(:id)
    
    @random_check_qty_progress = Inventory.random_check_completed.group('year(random_check_time)').group('month(random_check_time)').group('day(random_check_time)').count(:random_check_qty)
    @random_check_qty_progress['未抽盘'] = Inventory.random_check.count(:id)
    
    @check_qty_hour_progress = Inventory.where("check_qty != ''").group('year(check_time)').group('month(check_time)').group('day(check_time)').group('hour(check_time)').count(:id)
    
    @random_check_qty_hour_progress = Inventory.random_check_completed.group('year(random_check_time)').group('month(random_check_time)').group('day(random_check_time)').group('hour(random_check_time)').count(:id)
    
  end
end

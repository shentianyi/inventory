include ActionView::Helpers::NumberHelper
class DashboardController < ApplicationController
  def index

    #@check_qty_progress = Inventory.where("check_qty != ''").group('date(check_time)').count(:id)
    ## @check_qty_progress = Inventory.where("check_qty != ''").group("date_format(check_time, '%Y-%m-%d')").count(:id).map {|check_time, count_id| [check_time, (count_id/Inventory.where("check_qty != ''").count.to_f * 100).round(0)] }


    #@check_qty_tmp = @check_qty_progress.collect { |item| {:name => item[0].strftime('%m-%d'), :y => item[1]} }
    #@check_qty_tmp << {:name => "未全盘", :y => Inventory.where("check_qty is null").count(:id)}
    #@check_qty_tmp_size=@check_qty_tmp.size

    #puts "the hash array json #{@check_qty_tmp}"

    ## puts @check_qty_progress
    ##@check_qty_progress['未全盘'] = Inventory.where("check_qty is null").count(:id)


    #@random_check_qty_progress = Inventory.random_check_completed.group('date(random_check_time)').count(:random_check_qty)
    ## @random_check_qty_progress['未抽盘'] = Inventory.random_check.count(:id)
    ## @random_check_qty_progress['未抽盘'] = Inventory.random_check_not.count(:id)
    #@random_check_qty_tmp = @random_check_qty_progress.collect { |item| {:name => item[0].strftime('%m-%d'), :y => item[1]} }
    #@random_check_qty_tmp << {:name => "未抽盘", :y => Inventory.random_check_not.count(:id)}
    #@random_check_qty_tmp_size=@random_check_qty_tmp.size
    ## @check_qty_hour_progress = Inventory.where("check_qty != ''").group("date_format(check_time, '%Y-%m-%d %H点')").count(:id)
    ## @random_check_qty_hour_progress = Inventory.random_check_completed.group("date_format(random_check_time, '%Y-%m-%d %H点')").count(:id)


    #@check_qty_hour_progress = Inventory.where("check_qty != ''").group("date_format(check_time, '%m-%d %H点')").count(:id)
    #@random_check_qty_hour_progress = Inventory.random_check_completed.group("date_format(random_check_time, '%m-%d %H点')").count(:id)

    @data=[]
    query=Inventory.select('count(*) as value')
    base_query=Inventory.group(:department).select('count(*) as value,department')
    departments=Inventory.pluck(:department).uniq<<'总计'
    # 共计盘点项
    total_inven=gen_data(base_query)
    total_inven['总计']=query.first.value

    # 原有盘点项
    origin_inven=gen_data(base_query.where('ios_created_id is null'))
    origin_inven['总计']=query.where('ios_created_id is null').first.value
    # 新建盘点项
    new_inven=gen_data(base_query.where('ios_created_id is not null'))
    new_inven['总计']=query.where('ios_created_id is not null').first.value

    # 已全盘
    check_inven=gen_data(base_query.where('check_qty is not null'))
    check_inven['总计']=query.where('check_qty is not null').first.value

    # 未全盘
    not_check_inven=gen_data(base_query.where('check_qty is null'))
    not_check_inven['总计']=query.where('check_qty is null').first.value

    # 抽盘量
    random_total_inven=gen_data(base_query.where(is_random_check: true))
    random_total_inven['总计']=query.where(is_random_check: true).first.value

    # 已抽盘
    random_check_inven=gen_data(base_query.where(is_random_check: true).where('random_check_qty is not null'))
    random_check_inven['总计']=query.where(is_random_check: true).where('random_check_qty is not null').first.value

    # 未抽盘
    random_not_check_inven=gen_data(base_query.where(is_random_check: true).where('random_check_qty is null'))
    random_not_check_inven['总计']=query.where(is_random_check: true).where('random_check_qty is null').first.value

    # 抽盘修正
    changed_check_inven=gen_data(base_query.where(is_random_check: true).where('check_qty!=random_check_qty and (check_qty is not null) and (random_check_qty is not null)'))
    changed_check_inven['总计']=query.where(is_random_check: true).where('check_qty!=random_check_qty and (check_qty is not null) and (random_check_qty is not null)').first.value


    departments.each do |department|
      @data<<{
          department: department,
          total_inven: total_inven[department],
          origin_inven: origin_inven[department].to_i,
          origin_inven_percent: nil_or_zero(total_inven[department]) ? 0 : "#{((origin_inven[department].to_i/(total_inven[department].to_f))*100).round(2)}%",
          new_inven: new_inven[department].to_i,
          new_inven_percent: nil_or_zero(total_inven[department]) ? 0 : "#{((new_inven[department].to_i/(total_inven[department].to_f))*100).round(2)}%",
          check_inven: check_inven[department].to_i,
          check_inven_percent: nil_or_zero(total_inven[department]) ? 0 : "#{((check_inven[department].to_i/(total_inven[department].to_f))*100).round(2)}%",
          not_check_inven: not_check_inven[department].to_i,
          not_check_inven_percent: nil_or_zero(total_inven[department]) ? 0 : "#{((not_check_inven[department].to_i/(total_inven[department].to_f))*100).round(2)}%",
          random_total_inven: random_total_inven[department].to_i,
          random_total_inven_percent: nil_or_zero(total_inven[department]) ? 0 : "#{((random_total_inven[department].to_i/(total_inven[department].to_f))*100).round(2)}%",
          random_check_inven: random_check_inven[department].to_i,
          random_check_inven_percent: nil_or_zero(random_total_inven[department]) ? 0 : "#{((random_check_inven[department].to_i/(random_total_inven[department].to_f))*100).round(2)}%",
          random_not_check_inven: random_not_check_inven[department].to_i,
          random_not_check_inven_percent: nil_or_zero(random_total_inven[department]) ? 0 : "#{((random_not_check_inven[department].to_i/(random_total_inven[department].to_f))*100).round(2)}%",
          changed_check_inven: changed_check_inven[department].to_i,
          changed_check_inven_percent: nil_or_zero(random_total_inven[department]) ? 0 : "#{((changed_check_inven[department].to_i/(random_total_inven[department].to_f))*100).round(2)}%"
      }
    end
  end


  def setting

  end

  private
  def gen_data query
    query.map { |i| [i.department, i.value] }.to_h
  end

  def nil_or_zero value
    value.nil? || value==0
  end
end

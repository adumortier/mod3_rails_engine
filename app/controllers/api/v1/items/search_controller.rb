class Api::V1::Items::SearchController < ApplicationController 

  def show 
    @items = filter
    render json: ItemSerializer.new(@items.first)
  end

  def index
    @items = filter
    render json: ItemSerializer.new(@items)
  end
  
  private 
    
  def filter 
    @items = Item.where(nil)
    @items = @items.filter_by_name(params[:name]) if params[:name].present? 
    @items = @items.filter_by_description(params[:description]) if params[:description].present? 
    @items = @items.filter_by_unit_price(params[:unit_price]) if params[:unit_price].present? 
    @items = @items.filter_by_created_at(params[:created_at]) if params[:created_ad].present? 
    @items = @items.filter_by_updated_at(params[:updated_at]) if params[:updated_ad].present? 
    @items
  end

end
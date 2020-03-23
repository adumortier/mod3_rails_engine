class Api::V1::ItemsController < ApplicationController 

  def index
    if params[:merchant_id]
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show 
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create 
    merchant = Merchant.find(item_params[:merchant_id])
    render json: ItemSerializer.new(merchant.items.create(item_params))
  end

  def update 
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy 
    item = Item.find(params[:id])
    Item.delete(params[:id])
    render json: ItemSerializer.new(item)
  end

  private 

  def item_params
    if params[:item]
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    else
      params.permit(:name, :description, :unit_price, :merchant_id)
    end
  end

end
class Api::V1::MerchantsController < ApplicationController 

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:item_id]
      render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
    else 
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end

  def create 
    render json: MerchantSerializer.new(Merchant.create(merchant_params))
  end

  def update 
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def destroy
    merchant = Merchant.find(params[:id])
    Merchant.delete(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  private 
  
  def merchant_params
    params.require("merchant").permit("name")
  end

end
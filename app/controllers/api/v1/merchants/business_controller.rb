class Api::V1::Merchants::BusinessController < ApplicationController 

  def most_revenue 
    quantity = params[:quantity]
    merchants = Merchant.most_revenue(quantity)
    render json: MerchantSerializer.new(merchants)
  end

  def most_items 
    quantity = params[:quantity]
    merchants = Merchant.most_items(quantity)
    render json: MerchantSerializer.new(merchants)
  end

  def revenue 
    result = Merchant.total_revenue(params[:start], params[:end])
    output = {"data": {"id": nil, "attributes":{"revenue": result} } }
    render json: output
  end

  def merchant_revenue
    result = Merchant.revenue(params["merchant_id"])
    output = {"data": {"id": nil, "attributes":{"revenue": result} } }
    render json: output
  end

end
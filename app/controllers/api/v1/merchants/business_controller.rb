class Api::V1::Merchants::BusinessController < ApplicationController 

  def most_revenue 
    quantity = params[:quantity]
    merchants = Merchant.joins(:invoice_items, :transactions).where(transactions: {result: 1}).select('merchants.*, sum(invoice_items.unit_price*invoice_items.quantity) as revenue').group(:id).order(revenue: :desc).limit(quantity)
    render json: MerchantSerializer.new(merchants)
  end

  def most_items 
    quantity = params[:quantity]
    merchants = Merchant.joins(:invoice_items, :transactions).where(transactions: {result: 1}).select('merchants.*, sum(invoice_items.quantity) as total_quantity').group(:id).order(total_quantity: :desc).limit(quantity)
    render json: MerchantSerializer.new(merchants)
  end

  def revenue 
    start_date = params[:start]
    end_date = params[:end]
    @invoices = Invoice.joins(:invoice_items, :transactions).where(transactions: {result: 1})
    result = @invoices.where(:created_at => start_date..end_date).sum('invoice_items.quantity * invoice_items.unit_price')
    output = {"data": {"id": nil, "attributes":{"revenue": result} } }
    render json: output
  end

  def merchant_revenue
    result = Merchant.joins(:invoice_items).joins(:transactions).where(merchants: {id: params["merchant_id"]}).sum('invoice_items.unit_price*invoice_items.quantity')
    output = {"data": {"id": nil, "attributes":{"revenue": result} } }
    render json: output
  end

end
class Api::V1::Merchants::SearchController < ApplicationController 

  def show
    @merchants = filter
    render json: MerchantSerializer.new(@merchants.first)
  end

  def index 
    @merchants = filter.order(:name)
    render json: MerchantSerializer.new(@merchants)
  end

  private

  def filter
    @merchants = Merchant.where(nil)
    @merchants = @merchants.filter_by_name(params[:name]) if params[:name].present?
    @merchants = @merchants.filter_by_created_at(params[:created_at]) if params[:created_at].present?
    @merchants = @merchants.filter_by_updated_at(params[:updated_at]) if params[:updated_at].present?
    @merchants
  end

end
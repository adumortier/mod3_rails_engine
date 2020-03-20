class Api::V1::Merchants::SearchController < ApplicationController 

  def show 
    merchant = Merchant.where(Merchant.arel_table[:name].lower.matches("%#{params['name'].downcase}%"))
    require 'pry'; binding.pry
    # query = Merchant.params_to_query(params)
    # if params['name']
    #   merchant = Merchant.where("name = #{params['name']}")
    #   require 'pry'; binding.pry
    #   render json: MerchantSerializer.new(Merchant.where(name: params['name']).first)
    # end
  end

end
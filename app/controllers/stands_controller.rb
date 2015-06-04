class StandsController < ApplicationController
  def index
    @stands = if params[:direction].present?
                     Stand.order(price: params[:direction].to_sym)
                   else
                     Stand.order(:id)
                   end
  end
end

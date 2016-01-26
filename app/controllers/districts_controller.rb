class DistrictsController < ApplicationController
  def show
    @district = District.find(params[:id])
  end
end

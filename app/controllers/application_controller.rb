class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_data

  def prepare_data
    @all_delivery_pages ||= ::DeliveryPage.all
    @all_aquas ||= ::Aqua.includes(:volumes).select(:id, :name, :id).order(:id)
    f_aqua = @all_aquas.first
    @a_volumes = f_aqua.volumes.sort_by(&:title_value)
    @aqua_price = ::OrderService.get_price(f_aqua.id, @a_volumes.first.id, 2)
    @deposit = @a_volumes.first.deposit.to_i * 2
    @items = ::Cooler.includes(:images).select(:id, :title, :price).first(10)
    @items += ::Accessory.select(:id, :title, :price, :image).first(10)
    @items += ::Product.select(:id, :title, :price, :image).first(10)
    @actions = ::Article.where(type: 'promotion').all
  end
end

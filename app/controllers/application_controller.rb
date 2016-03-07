class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_data

  def prepare_data
    @all_delivery_pages ||= ::DeliveryPage.all
    @all_aquas ||= ::Aqua.includes(:volumes).select(:id, :name, :id).order(:id)
    f_aqua = @all_aquas.first
    @a_volumes = f_aqua.volumes.sort_by { |v| v.value == 19 && !v.pet && !v.soda ? -20 : -1 * v.value.to_i }
    @aqua_price = ::OrderService.get_price(f_aqua.id, @a_volumes.first.id, 2)
    @deposit = @a_volumes.first.deposit.to_i * 2
    @items = ::Cooler.includes(:images).select(:id, :title, :price).where(orderable: true).to_a
    [::Accessory, ::Product, ::Pomp ].each do |klass|
      @items.concat(klass.select(:id, :title, :price, :image).where(orderable: true).to_a)
    end
  end
end

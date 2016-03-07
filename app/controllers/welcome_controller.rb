class WelcomeController < ApplicationController
  def home
    aqua = Aqua.first
    gon.price_19 = aqua.prices.where(volume_id: aqua.volumes.where(value: 19).first).pluck(:value).min
    gon.price_8 = aqua.prices.where(volume_id: aqua.volumes.where(value: 8).first).pluck(:value).min
    gon.price_6 = aqua.prices.where(volume_id: aqua.volumes.where(value: 6).first).pluck(:value).min
    gon.price_1 = aqua.prices.where(volume_id: aqua.volumes.where(value: 0.6).first).pluck(:value).min
    @polygons = Polygon.all
    @polygons_coords = []
    @polygons_coords << @polygons.map{|p| p.coordinates.split(';').map{|c| c.split(',')}.map{|a| a.map{|c| c.to_f}}}
    gon.polygons_coords = @polygons_coords[0]
    gon.polygons = @polygons
    @odd_actions = []
    @even_actions = []
    ::Article.where(type: "promotion").each_with_index do |art, i|
      (i.odd? ? @odd_actions : @even_actions) << art
    end
  end

  def contacts; end

  def payment; end

  def profile
    redirect_to root_path unless current_user
  end

  def orders
    if current_user
      @orders = current_user.orders.order(created_at: :desc)
    else
      redirect_to root_path
    end
  end

  def about
    @posts = CompanyPost.all
  end

  def delivery
    @district = District.search(params[:name])
    gon.district = @district.select(:lon, :lat, :map_popup, :name)
    @district_ajax = @district.select(:lon, :lat) if request.xhr?
    @district = @district.order(:name).group_by{|u| u.name[0]}
  end

  def events
    @articles = Article.order(id: :desc)
    @articles = @articles.where(type: params[:type]) if params[:type].present?
  end

  def events_show
    @event = Article.find(params[:id])
  end

  def check_time
    render json: OrderService.check_date(params[:data])
  end

  def service
    @service_page = PageContent.service
  end
end

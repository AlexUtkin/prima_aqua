class CoolersController < ApplicationController
  def index
    @coolers = Cooler.all
    @coolers = @coolers.joins(:tags).where(tags: {name: params[:tag]}) if params[:tag].present?
    @coolers = @coolers.where(type_cooling: params[:type_cooling]) if params[:type_cooling].present?

    (s = params[:type_construction].presence) && @coolers = @coolers.where('type_construction LIKE ?', "%#{s[2..4]}%")

    @coolers = if params[:direction].present?
                 @coolers.order(price: params[:direction].to_sym)
               else
                 @coolers.to_a.sort_by { |cooler| cooler.has_tag?('Выгодно') ? 0 : 1}
               end
    @tags = Tag.includes(:coolers).where(main: true).limit(4)
  end

  def show
    @cooler = Cooler.find(params[:id])
  end

  def get_image
    @image = Image.find(params[:id])
  end
end

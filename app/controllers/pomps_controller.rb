class PompsController < ApplicationController
  def index
    @pomps = Pomp.order(:id)
    @tags = Tag.includes(:coolers).limit(4)
  end
end
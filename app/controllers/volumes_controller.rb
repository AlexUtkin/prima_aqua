class VolumesController < ApplicationController
  skip_before_action :prepare_data, only: :index
  def index
    aqua = Aqua.find(params[:aqua_id])
    volumes = aqua.volumes.sort_by(&:title_value).map { |v| "#{v.id}-#{v.title_value}" }
    render json: { volumes: volumes }
  end
end

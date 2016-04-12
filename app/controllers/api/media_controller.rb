class Api::MediaController < ApplicationController
  def index
    media = Medium.where(category: params[:category])
    render json: media, each_serializer: MediumSerializer
  end
end

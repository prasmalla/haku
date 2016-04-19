class Api::MediaController < ApplicationController
  def start
    render text: 'start here'
  end

  def index
    media = Medium.where(category: params[:category]).order('created_at ASC').paginate(page: params[:page], per_page: 20)
    render json: media, each_serializer: MediumSerializer, meta: pagination_dict(media)
  end

  def pagination_dict(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.previous_page,
      total_pages: object.total_pages
    }
  end
end

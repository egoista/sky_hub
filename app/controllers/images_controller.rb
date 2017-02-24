class ImagesController < ApplicationController
  def show
    render json: Image.all_json_formatted
  end

  def populate
    image_service = ImagesWebService.new(CONFIG['images_web_service_url'])

    Image.create_from_urls(image_service.photos_urls, request.base_url)

    head :ok, content_type: 'text/html'
  end
end

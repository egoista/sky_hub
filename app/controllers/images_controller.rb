class ImagesController < ApplicationController
  def show
    render json: Image.all_json_formatted
  end

  def populate
    image_service = ImagesWebService.new(CONFIG['images_web_service_url'])

    ImageCreateFromUrlsJob.perform_async(image_service.photos_urls)

    render json: 'The system is running a assync process, it may take a while to generate all the photos.', status: :ok
  end
end

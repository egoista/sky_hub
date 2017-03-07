class ImageCreateFromUrlsJob 
  include SuckerPunch::Job
  
  def perform(urls)
    Image.create_from_urls(urls)
  end
end

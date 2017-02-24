class ImagesWebService
  def initialize(url)
    @url = url
  end

  def photos_urls
   response = Typhoeus.get @url
   hash = JSON.parse response.body

   hash['images'].map{|image| image['url']}
  end
end
class ImageEdit
  def self.resize_from_url(url, height, width, save_path)
    image = MiniMagick::Image.open url
    image.resize "#{height}x#{width}"
    image.write(save_path)
  end
end
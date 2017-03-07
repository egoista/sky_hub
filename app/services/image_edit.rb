class ImageEdit
  attr_accessor :image

  def self.create_from_url(url)
    image_edit = self.new
    image_edit.image = MiniMagick::Image.open url

    image_edit
  end

  def resize(height, width)
    @image.resize "#{height}x#{width}"
  end

  def path
    @image.path
  end
end
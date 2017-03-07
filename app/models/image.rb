class Image
  include Mongoid::Document

  field :file_name, type: String
  field :source, type: String

  embeds_many :image_versions

  def self.create_from_urls(urls)
    urls.each do |url|
      unless self.where(source: url).exists?
        source_file_name = url[/([^\/]+)\/?$/, 1]
        image = self.create(
            file_name: source_file_name,
            source: url,
        )

        CONFIG['image_dimensions'].each do |size_name, dimensions|
          file_name = "#{size_name}_#{source_file_name}"
          edited_image = ImageEdit.create_from_url(url).resize(dimensions['height'], dimensions['width'])
          public_url = FileStorage.upload_public_file(file_name, edited_image.path)

          ImageVersion.create(
              image: image,
              alias: size_name,
              public_url: public_url
          )

        end

        image.save
      end
    end
  end

  def self.all_json_formatted
    result = Hash.new
    self.all.each do |image|
      result[image.file_name] = Hash.new
      image.image_versions.each do |image_version|
        result[image.file_name][image_version.alias] = image_version.public_url
      end
    end

    result.to_json
  end
end
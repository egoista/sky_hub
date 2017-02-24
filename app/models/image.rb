class Image
  include Mongoid::Document

  field :file_name, type: String
  field :source, type: String

  embeds_many :image_versions

  def self.create_from_urls(urls, host)
    urls.each do |url|
      file_name = url[/([^\/]+)\/?$/, 1]
      unless self.where(file_name: file_name).exists?
        image = self.create(
            file_name: file_name,
            source: url,
        )

        CONFIG['image_dimensions'].each do |size_name, dimensions|
          image_version = ImageVersion.create(
              image: image,
              alias: size_name,
              path: Rails.root.join(CONFIG['images_folder'],"#{size_name}_#{file_name}").to_s,
              url: "#{host}/#{CONFIG['images_folder']}/#{size_name}_#{file_name}"
          )

          ImageEdit.resize_from_url(url, dimensions['height'], dimensions['width'], image_version.path)
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
        result[image.file_name][image_version.alias] = image_version.url
      end
    end

    result.to_json
  end
end
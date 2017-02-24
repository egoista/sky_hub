class ImageVersion
  include Mongoid::Document

  field :alias, type: String
  field :path, type: String
  field :url, type: String

  embedded_in :image
end
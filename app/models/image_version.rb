class ImageVersion
  include Mongoid::Document

  field :alias, type: String
  field :public_url, type: String

  embedded_in :image
end
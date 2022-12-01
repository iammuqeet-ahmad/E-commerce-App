class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :image_urls

  def image_urls
    urls=object.photos.map{|photo|
      photo.service_url
    }
  end
end

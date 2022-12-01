class ProductsSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :price, :image_url

  def image_url
    object.photos.first.service_url
  end
end

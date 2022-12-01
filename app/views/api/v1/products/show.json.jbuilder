json.id @product.id
json.name @product.name
json.description @product.description
json.price @product.price
json.images @product.photos do |photo|
  json.url url_for(photo)
end

json.extract! product, :id, :name, :description, :price, :sale_price, :quantity, :created_at, :updated_at
json.url product_url(product, format: :json)

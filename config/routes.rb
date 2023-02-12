Rails.application.routes.draw do
  resources :products
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "products#index"

  get 'carts' => 'carts#index', as: 'cart'
  delete 'carts/:id' => 'carts#destroy', as: 'cart_destroy'

  post 'line_items/:id/add' => 'line_items#add_quantity', as: 'line_item_add'
  post 'line_items/:id/reduce' => 'line_items#reduce_quantity', as: 'line_item_reduce'
  post 'line_items' => 'line_items#create'
  get 'line_items/:id' => 'line_items#show', as: 'line_item'
  delete 'line_items/:id' => 'line_items#destroy', as: 'line_item_destroy'

  post 'review' => 'product_reviews#create', as: 'product_review'
  post 'review/:id' => 'product_reviews#update', as: 'product_review_update'
  delete 'review/:id' => 'product_reviews#destroy', as: 'product_review_destroy'

  resources :orders
end

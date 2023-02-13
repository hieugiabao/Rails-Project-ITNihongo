class ProductLikesController < ApplicationController
  before_action :logged_in_user, only: %i[index, create, destroy]

  def index
    @products = Product.joins(:product_likes).where(product_likes: { user_id: current_user.id }).paginate(page: params[:page], per_page: 5)
  end

  def create
    @product_like = ProductLike.new
    @product_like.product_id = params[:product_id]
    @product_like.user_id = current_user.id
    if @product_like.save
      flash[:notice] = "Added product to your favourite!"
      redirect_back(fallback_location: root_url)
    else
      flash[:notice] = "Something went wrong!"
      redirect_back(fallback_location: root_url)
    end
  end

  def destroy
    @product_like = ProductLike.find_by(product_id: params[:product_id])
    if @product_like.user_id != current_user.id
      flash[:notice] = "You don't have the privilages for this action!"
      redirect_back(fallback_location: root_url)
      return
    end
    @product_like.destroy
    flash[:notice] =  "Removed product from your favourite!"
    redirect_back(fallback_location: root_url)
  end

  private
end

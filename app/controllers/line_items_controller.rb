class LineItemsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy add_quantity reduce_quantity]

  def create
    chosen_product = Product.find(params[:product_id])
    add_items_to_cart(chosen_product)
    respond_to do |format|
      if @line_item.save!
        flash[:notice] = 'Product added to cart!'
        format.html { redirect_back(fallback_location: @current_cart) }
        format.js
      else
        format.html { render :new, notice: 'Error adding product to cart!' }
      end
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy
    flash[:notice] = 'Product removed from cart!'
    redirect_back(fallback_location: @current_cart)
  end

  def add_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity < @line_item.product.quantity
      @line_item.quantity += 1
      @line_item.save
      flash[:notice] = 'Product quantity increased!'
    else
      flash[:notice] = 'Product quantity is at maximum!'
    end
    redirect_back(fallback_location: @current_cart)
  end

  def reduce_quantity
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
      @line_item.save
      flash[:notice] = 'Product quantity reduced!'
      redirect_back(fallback_location: @current_cart)
    elsif @line_item.quantity == 1
      destroy
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:quantity, :product_id, :cart_id)
  end

  def add_items_to_cart(product)
    # If cart already has this product then find the relevant line_item
    # and iterate quantity otherwise create a new line_item for this product
    if @current_cart.products.include?(product)
      @line_item = @current_cart.line_items.find_by(product_id: product)
      if @line_item.quantity < product.quantity
        @line_item.quantity += 1
      end
    else
      @line_item = LineItem.new
      @line_item.cart = @current_cart
      @line_item.product = product
      @line_item.quantity = 1
    end
  end
end

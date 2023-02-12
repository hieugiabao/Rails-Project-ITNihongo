class OrdersController < ApplicationController
  before_action :logged_in_user, only: %i[index, show, new, create]
  before_action :user_is_admin, only: %i[destroy, edit]
  before_action :cart_is_empty, only: %i[new, create]

  def index
    if !current_user.admin?
      @orders = Order.where(user_id: current_user.id).order('created_at DESC').paginate(page: params[:page], per_page: 5)
    else
      @orders = Order.all
      @orders = if params[:search]
        Order.search(params[:search]).order('created_at DESC')
        .paginate(page: params[:page], per_page: 5)
      else
        @orders.order('created_at DESC')
        .paginate(page: params[:page], per_page: 5)
      end
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @cart = @current_cart
  end

  def create
    @order = Order.new(order_params)
    @order.update(user_id: @current_user.id)
    @order.save!
    add_line_items_to_order
    reset_sessions_cart
    redirect_to orders_path
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_path }
      format.json { head :no_content }
      flash[:info] = 'Order was successfully destroyed.'
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    redirect_to orders_path
  end

  def cart_is_empty
    return unless @current_cart.line_items.empty?

    session[:forwarding_url] = request.original_url if request.get?
    flash[:danger] = 'You cart is empty!'
    redirect_to cart_path
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :pay_method, :description)
  end

  def reset_sessions_cart
    Cart.destroy(@current_cart.id)
  end

  def add_line_items_to_order
    @current_cart.line_items.each do |item|
      # decrement product quantity
      item.product.quantity -= item.quantity
      item.product.save
      item.cart_id = nil
      item.order_id = @order.id
      item.save
      @order.line_items << item
    end
  end
end

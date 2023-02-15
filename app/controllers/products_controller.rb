class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :user_is_admin, only: %i[create edit update destroy]

  # GET /products or /products.json
  def index
    fetch_products
  end

  # GET /products/1 or /products/1.json
  def show
    @product_review = if is_ordered
                        ProductReview.new
                      else
                        nil
                      end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :sale_price, :quantity, :cover)
    end

    def fetch_products
      @products = if params[:search]
                    Product.search(params[:search])
                          .order(created_at: :asc)
                          .paginate(page: params[:page], per_page: 5)
                  else
                    Product.order(created_at: :asc)
                           .paginate(page: params[:page], per_page: 5)
                  end
    end

    def is_ordered
      if current_user.nil?
        return false
      end
      current_user.orders.each do |order|
        order.line_items.each do |line_item|
          return true if line_item.product_id == @product.id
        end
      end
      false
    end
end

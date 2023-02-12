class ProductReviewsController < ApplicationController
  before_action :logged_in_user

  def create
    @product_review = ProductReview.new(product_review_params)
    @product_review.user = current_user

    respond_to do |format|
      if @product_review.save
        url = "/products/" + @product_review.product_id.to_s
        format.html { redirect_to url, notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @product_review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_review.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product_review = ProductReview.find(params[:id])
    url = "/products/" + @product_review.product_id.to_s
    if @product_review.user.id != current_user.id
      flash[:danger] = 'Not permission'
      redirect_to url and return
    end

    respond_to do |format|
      if @product_review.update(product_review_params)
        format.html { redirect_to url, notice: "Product review was successfully updated." }
        format.json { render :show, status: :ok, location: @product_review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_review.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_review = ProductReview.find(params[:id])
    url = "/products/" + @product_review.product_id.to_s
    if @product_review.user.id != current_user.id
      flash[:danger] = 'Not permission'
      redirect_to url and return
    else
      @product_review.destroy
      flash[:notice] = 'Delete review success'
      redirect_to url
    end
  end

  private

  def product_review_params
    params.require(:product_review).permit(:user_id, :product_id, :content, :rate)
  end
end

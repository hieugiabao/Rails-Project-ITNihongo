class Product < ApplicationRecord
  has_one_attached :cover
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items
  has_many :product_reviews, dependent: :destroy
  has_many :product_likes, dependent: :destroy

  def self.search(search)
    where('name LIKE ?', "%#{search}%")
  end

  def avg_rate
    sum = 0
    product_reviews.each do |product_review|
      sum += product_review.rate
    end
    if product_reviews.count == 0
      rate = 0
    else
      rate = sum.to_f / product_reviews.count
    end
    rate.round(1)
  end

  def review_paginate(page)
    product_reviews.order('updated_at DESC').paginate(page: page, per_page: 5)
  end
end

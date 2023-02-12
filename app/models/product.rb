class Product < ApplicationRecord
  has_one_attached :cover
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items
  has_many :product_reviews, dependent: :destroy

  def self.search(search)
    where('name LIKE ?', "%#{search}%")
  end

  def self.avg_rate
    sum = 0
    product_reviews.each do |product_review|
      sum += product_review.rate
    end
    sum / product_reviews.count
  end
end

class Product < ApplicationRecord
  has_one_attached :cover
  has_many :line_items, dependent: :destroy
  has_many :orders, through: :line_items

  def self.search(search)
    where('name LIKE ?', "%#{search}%")
  end
end

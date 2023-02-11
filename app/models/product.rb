class Product < ApplicationRecord
  has_one_attached :cover

  def self.search(search)
    where('name LIKE ?', "%#{search}%")
  end
end

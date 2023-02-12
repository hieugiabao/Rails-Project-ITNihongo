class CreateProductReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :product_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :content
      t.integer :rate

      t.timestamps
    end
  end
end

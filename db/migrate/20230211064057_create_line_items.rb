class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.references :product, null: false, foreign_key: true
      t.references :cart, null: true, foreign_key: true
      t.references :order, null: true, foreign_key: true

      t.timestamps
    end
  end
end

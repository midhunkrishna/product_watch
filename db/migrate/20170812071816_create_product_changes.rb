class CreateProductChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :product_changes do |t|
      t.references :group
      t.references :competitor
      t.text       :change_data

      t.timestamps
    end
  end
end

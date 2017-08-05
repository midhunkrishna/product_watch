class CreateCompetitors < ActiveRecord::Migration[5.1]
  def change
    create_table :competitors do |t|
      t.integer :price
      t.string :title
      t.text :images
      t.text :features
      t.integer :number_of_reviews
      t.integer :best_seller_rank
      t.integer :inventory
      t.references :group

      t.timestamps
    end
  end
end

class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :asin
      t.text :url

      t.timestamps
    end
  end
end

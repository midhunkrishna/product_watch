class AddAsinAndUrlToCompetitors < ActiveRecord::Migration[5.1]
  def change
    add_column :competitors, :asin, :string
    add_column :competitors, :url, :text
  end
end

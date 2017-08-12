class ChangeColumnDataTypesForCompetitor < ActiveRecord::Migration[5.1]
  def change
    change_column :competitors, :inventory, :string
    change_column :competitors, :price, :string
    change_column :competitors, :best_seller_rank, :string
  end
end

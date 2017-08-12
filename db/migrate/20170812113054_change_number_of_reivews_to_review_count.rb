class ChangeNumberOfReivewsToReviewCount < ActiveRecord::Migration[5.1]
  def change
    rename_column :competitors, :number_of_reviews, :review_count
  end
end

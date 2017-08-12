class ProductChange < ApplicationRecord
  serialize :change_data, Hash

  belongs_to :group
  belongs_to :competitor
end

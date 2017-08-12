class Competitor < ApplicationRecord
  include StringHelper
  include ProductConcerns::Asin

  belongs_to :group
  validates :asin, :url, presence: :true

  before_validation :generate_asin_or_url
end

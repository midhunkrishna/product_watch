class Group < ApplicationRecord
  include StringHelper
  include ProductConcerns::Asin

  has_many :competitors, inverse_of: :group

  accepts_nested_attributes_for :competitors, reject_if: :all_blank, allow_destroy: true

  validates :asin, :url, presence: :true

  before_validation :generate_asin_or_url
end

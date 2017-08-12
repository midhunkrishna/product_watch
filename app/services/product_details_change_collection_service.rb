class ProductDetailsChangeCollectionService
  def initialize(product)
    @product = product
  end

  def process
    detail_collector = ProductDetailCollectionService.new(@product.url, @product.asin)
    details = detail_collector.process

    @product.assign_attributes(details)

    if @product.changed?
      ActiveRecord::Base.transaction do
        ProductChange.create!(group_id: @product.group.id,
                              competitor_id: @product.id,
                              change_data: @product.changes)
        @product.save!
      end
    end
  end
end

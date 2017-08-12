class ProductDetailCollectionService
  include StringHelper

  def initialize(url, asin)
    @product_page = url
    @asin = asin
  end

  def process
    collect_product_details
  end

  private

  def collect_product_details
    attributes = [:price, :title, :images, :features, :review_count, :best_seller_rank, :inventory]
    attributes.inject({}) do |detail, attribute|
      detail[attribute] = send(attribute)
      detail
    end
  end

  def page
    @_page ||= Mechanize.new.get(@product_page)
  end

  def price
    page.at("#priceblock_ourprice").text.strip
  end

  def inventory
    InventoryRetrievalService.new(@product_page, @asin).process
  end

  def title
    page.at("#productTitle").text.strip
  end

  def images
    page.css('#altImages li img').collect do |image|
      image.attributes['src'].try(:value)
    end
  end

  def features
    page.css("#feature-bullets").collect { |feature| feature.text.strip }
  end

  def review_count
    "#{page.css("#acrCustomerReviewText").text.strip}"[/\d+/].to_i
  end

  def best_seller_rank
    best_seller_delimiter_start = 'Amazon Best Sellers Rank:'
    best_seller_delimiter_stop = '(See Top 100 in Sports & Outdoors)'

    rank = page.css("#detail-bullets #SalesRank").text
    substring_between(best_seller_delimiter_start, best_seller_delimiter_stop, rank)
      .try(:gsub, '(', '')
      .try(:strip)
  end
end

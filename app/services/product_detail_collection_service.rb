class ProductDetailCollectionService

  def initialize(url)
    @product_page = url
  end

  def process
    details = collect_product_details
  end

  private

  def collect_product_details
    attributes = [:price, :title, :images, :features, :review_count, :best_seller_rank]
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

  def substring_between(start, stop, string)
    string[/#{start}(.*?)#{stop}/m, 1]
  end
end

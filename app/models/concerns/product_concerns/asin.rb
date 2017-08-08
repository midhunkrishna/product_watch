module ProductConcerns::Asin
  def generate_asin_or_url
    if asin.present?
      self.url = "https://www.amazon.com/dp/#{asin}/"
    elsif url.present?
      uri = URI.parse(url)
      self.asin = substring_between('dp/', '/', uri.path)
    end
  end
end

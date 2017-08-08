require 'rails_helper'

RSpec.describe ProductDetailCollectionService do
  let(:url) {
    'https://www.amazon.com/dp/B01K8B5BYU/'
  }

  let(:asin) {
    'B01K8B5BYU'
  }

  it 'returns product price' do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      service = described_class.new(url, asin)
      expect(service.send(:price)).to eq '$19.98 - $51.52'
    end
  end

  it 'returns product title' do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      service = described_class.new(url, asin)
      expect(service.send(:title)).to eq "Louisville Slugger Genuine Series 3X Ash Mixed Baseball Bat"
    end
  end

  it 'returns product images' do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      service = described_class.new(url, asin)
      expect(service.send(:images).count).to eq 3
    end
  end

  it 'returns product features' do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      service = described_class.new(url, asin)
      features = ["Louisville Slugger Genuine S3X Mixed Ash Wood Baseball Bat Louisville Slugger's adult wood bats are pulled from their original production line for some minor flaw that will not affect the bat's performance. These small production errors mean deep savings on superior bats ideal for practice, batting cages or even games. Bat Specifications Wood: Series 3X Ash Finishes: Natural Finish & Black Finish Turning Model: Mixed Cupped: Yes Available Sizes: $size$"]
      expect(service.send(:features)).to match_array(features)
    end
  end

  it 'returns product review count' do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      service = described_class.new(url, asin)
      expect(service.send(:review_count)).to eq 49
    end
  end

  it 'returns product best seller rank' do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      service = described_class.new(url, asin)
      expect(service.send(:best_seller_rank)).to eq "#11,995 in Sports & Outdoors"
    end
  end
end

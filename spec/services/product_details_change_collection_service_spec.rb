require 'rails_helper'

RSpec.describe ProductDetailsChangeCollectionService do
  let(:group) { create(:group) }

  it "should collect product change" do
    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      expect {
        described_class.new(group.competitors.last).process
      }.to change{
        ProductChange.count
      }.by(1)
    end
  end

  it "shouldn't collect changes of there are no changes" do
    allow_any_instance_of(ProductDetailCollectionService).to receive(:process).and_return({})

    VCR.use_cassette("#{described_class.name}", record: :new_episodes) do
      expect {
        described_class.new(group.competitors.last).process
      }.not_to change{
        ProductChange.count
      }
    end
  end
end

FactoryGirl.define do
  factory :group do
    asin "B01K8B5BYU"
    url "https://www.amazon.com/dp/B01K8B5BYU/"

    after :create do |group|
      create_list :competitor, 1, group: group
    end
  end
end

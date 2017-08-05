require 'rails_helper'

RSpec.describe Group, type: :model do
  it { should have_many(:competitors) }
end

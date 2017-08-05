require 'rails_helper'

RSpec.describe Competitor, type: :model do
  it { should belong_to(:group) }
end

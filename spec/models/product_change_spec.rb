require 'rails_helper'

RSpec.describe ProductChange, type: :model do
  it { should belong_to(:group) }
  it { should belong_to(:competitor) }
end

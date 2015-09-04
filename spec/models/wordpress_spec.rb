require 'rails_helper'

RSpec.describe Wordpress, type: :model do
  it 'belongs to user ' do
    expect(subject).to belong_to :user
  end

  it 'requires a user' do
    expect(subject).to validate_presence_of(:user)
  end
end

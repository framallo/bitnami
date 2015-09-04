require 'rails_helper'

RSpec.describe Wordpress, type: :model do
  it 'belongs to user ' do
    expect(subject).to belong_to :user
  end
end

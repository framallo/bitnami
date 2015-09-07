require 'rails_helper'

RSpec.describe 'key:create' do

  it 'return a new key' do
    expect do
      subject.invoke
    end.to output(/^[a-zA-Z\=0-9]{24}\n$/).to_stdout
  end
end

require 'rails_helper'

RSpec.describe 'key:create' do

  it 'return a new key' do
    expect do
      subject.invoke
    end.to output(/^.{23,24}$/).to_stdout
  end
end

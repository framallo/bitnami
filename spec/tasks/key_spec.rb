require 'rails_helper'

RSpec.describe 'key:create' do
  before { Bitnami::Application.load_tasks }

  it do
    expect do
      Rake::Task['key:create'].invoke
    end.to output(/^[a-zA-Z\=0-9]{24}$/).to_stdout
  end
end

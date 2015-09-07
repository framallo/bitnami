require 'rails_helper'

RSpec.describe Wordpress, type: :model do
  let(:user) { create(:user) }
  let(:subject) { described_class.new user: user }

  before(:each) do
    aws_stub_create
  end

  it 'belongs to user ' do
    expect(subject).to belong_to :user
  end

  it 'requires a user' do
    expect(subject).to validate_presence_of(:user)
  end

  context '#create_instance' do
    it 'creates a new instance after creation' do
      allow_any_instance_of(described_class)
        .to receive(:actually_create_instance)

      expect(subject).to receive(:create_instance)
        .and_call_original
      subject.save!
    end

    it 'creates a new worker' do
      expect do
        subject.save!
      end.to change(CreateInstanceWorker.jobs, :size).by(1)
    end

    it 'creates a new instance' do
      subject.save!
      CreateInstanceWorker.drain
      subject.reload
      puts subject.instance_id
      expect(subject.instance_id).not_to be_nil
    end
  end

  context '#actuall_create_instance' do
    it 'actually creates an instance' do
      allow(subject.instance).to receive(:create)
        .and_call_original
      subject.actually_create_instance
    end
  end
end

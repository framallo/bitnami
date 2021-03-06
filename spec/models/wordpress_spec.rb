require 'rails_helper'

RSpec.describe Wordpress, type: :model do
  let(:user) do
    user = build(:user)
    user.aws_access_key_id = aws_access_key_id
    user.aws_secret_access_key = aws_secret_access_key
    user.save!
    user
  end

  let(:wordpress_without_credentials) { build :wordpress_without_credentials }
  let(:subject) { build :wordpress }

  before(:each) do
    aws_stub_create
    aws_stub_describe_instance_status
  end

  it 'belongs to user' do
    expect(subject).to belong_to :user
  end

  it 'requires a user' do
    allow(subject).to receive(:user_must_have_credentials) { true }
    expect(subject).to validate_presence_of(:user)
  end

  context 'requires a user with credentials' do
    it 'fails when the user does not have credentials' do
      validation = wordpress_without_credentials.user_must_have_credentials

      expect(validation).to be false
    end

    it 'fails when the user does not have credentials' do
      expect(subject.user_must_have_credentials).to be true
    end
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
      expect(subject.instance_id).not_to be_nil
    end
  end

  context '#actually_create_instance' do
    it 'actually creates an instance' do
      allow(subject.instance).to receive(:create)
        .and_call_original
      subject.actually_create_instance
    end
  end

  context '#fetch_status' do
    let(:subject) { create :wordpress_with_instance }

    it 'creates a new worker' do
      expect do
        subject.fetch_status
      end.to change(WordpressStatusWorker.jobs, :size).by(1)
    end

    it 'calls actually_fetch_status' do
      allow_any_instance_of(described_class)
        .to receive(:actually_fetch_status)
      subject.fetch_status
      WordpressStatusWorker.drain
    end
  end
  context '#actually_fetch_status' do
    let(:subject) { create :wordpress_with_instance }

    it 'fetch status' do
      allow_any_instance_of(subject.instance.class)
        .to receive(:status)
        .and_call_original
      subject.actually_fetch_status
    end
  end
end

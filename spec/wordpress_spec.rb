require 'spec_helper'
require 'bitnami'

RSpec.describe Bitnami::Wordpress do
  before(:all) do
    aws_stub_security_group
    aws_stub_create
    aws_stub_describe_instance_status
  end

  describe '#ec2' do
    it 'returns an Ec2 instance' do
      expect(subject.ec2).to be_instance_of(Bitnami::Ec2)
    end
  end

  describe '#create' do
    it 'creates an instance' do
      expect(subject.ec2).to receive(:create_instance).and_call_original
      subject.create
    end

    it 'does not create an instance' do
      expect(subject.ec2).not_to receive(:create_instance)
      described_class.new('i-1abc1234').create
    end
  end

  describe '#status' do
    let(:id) { nil }
    subject { Bitnami::Wordpress.new(id) }

    context 'when it is an existing instance' do
      let(:id) { 'i-1abc1234' }

      it 'calls the describe_instance_status from ec2 instance' do
        expect(subject.ec2).to receive(:describe_instance_status)
          .and_call_original
        subject.status
      end

      it 'returns the status' do
        expect(subject.status).to_not be_nil
      end

      it 'returns a status struct' do
        expect(subject.status).to be_kind_of Bitnami::Wordpress::Status
      end
    end

    context 'when it is a new instance' do
      it 'returns nil' do
        expect(subject.status).to be_nil
      end
    end
  end

  describe '#find' do
    pending 'finds an instance'
  end
end

RSpec.describe Bitnami::Wordpress::Status do
  it { expect(subject).to respond_to :system_status }
  it { expect(subject).to respond_to :instance_status }
  it { expect(subject).to respond_to :state_name }
  it { expect(subject).to respond_to :state_code }
end

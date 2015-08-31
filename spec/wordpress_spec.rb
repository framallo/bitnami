require 'spec_helper'

def enable
  WebMock.disable!
  Aws.config = {}
end

def disable
  WebMock.enable!
end

RSpec.describe Bitnami::Wordpress do
  before(:all) do
    aws_stub_security_group
    aws_stub_create
  end

  context '#ec2' do
    it 'returns an Ec2 instance' do
      expect(subject.ec2).to be_instance_of(Bitnami::Ec2)
    end
  end

  context '#create' do
    it 'creates an instance' do
      # binding.pry
      expect(subject.ec2).to receive(:create_instance).and_call_original
      subject.create
    end

    it 'does not create an instance' do
      expect(subject.ec2).not_to receive(:create_instance)
      described_class.new('i-1abc1234').create
    end
  end

  context '#status' do
    it 'returns the status of the instance' do
      expect(subject.ec2).to receive(:describe_instance_status)
        .and_call_original
      subject.id = 'i-1abc1234'
      subject.status
    end

    it 'works without id' do
      expect { subject.status }.not_to raise_error
    end
  end
end

require 'spec_helper'
require 'bitnami'

RSpec.describe Bitnami::Ec2 do
  before(:all) do
    aws_stub_security_group
  end
  let(:aws_access_key_id) do
    ENV['AWS_ACCESS_KEY_ID'] || 'AAAAAAAAAAAAAAAAAAAA'
  end
  let(:aws_secret_access_key) do
    ENV['AWS_SECRET_ACCESS_KEY'] || '1aA11A/aaAAAaAAaaAAaaaa1aaAa1aaa1AAaaa11'
  end

  let(:subject) do
    described_class.new(aws_access_key_id, aws_secret_access_key)
  end

  context '#new' do
    it 'requires access_key_id and secret_access_key' do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  context '#credentials' do
    it 'has a valid credential' do
      expect(subject.credentials).to be_instance_of Aws::Credentials
    end
  end

  context '#resource' do
    it 'returns a valid resource' do
      expect(subject.resource).to be_instance_of Aws::EC2::Resource
    end
  end

  context 'settings' do
    it 'returns a region' do
      expect(subject.region).to eq('us-east-1')
    end

    it 'returns a group_name'do
      expect(subject.group_name).to eq('bitnami')
    end
  end

  context 'bitnami_security_group' do
    context '#find_bitnami_security_group' do
      it 'returns the bitnami security group' do
        security_group = subject.find_bitnami_security_group

        expect(security_group).to be_instance_of Aws::EC2::SecurityGroup
        expect(security_group.group_name).to eq 'bitnami'
      end
    end

    context '#create_bitnami_security_group' do
      it 'creates the security group' do
        security_group = subject.create_bitnami_security_group

        expect(security_group.group_id).to eq 'group-id'
      end
    end

    context '#bitnami_security_group' do
      it 'find the security group' do
        expect(subject).to receive(:find_bitnami_security_group)
          .and_call_original
        expect(subject).not_to receive :create_bitnami_security_group

        subject.bitnami_security_group
      end
      it 'does not find the security group' do
        expect(subject).to receive :find_bitnami_security_group
        expect(subject).to receive(:create_bitnami_security_group)
          .and_call_original

        subject.bitnami_security_group
      end
    end
  end

  context '#create_instance' do
    it 'creates an EC2 instance' do
      aws_stub_create
      expect(subject.resource).to receive(:create_instances)
        .and_call_original

      instance = subject.create_instance('i-1abc1234')
      expect(instance).to be_instance_of Aws::EC2::Instance
    end
  end

  context '#instance' do
    it 'finds an EC2 instance' do
      expect(subject.resource).to receive(:instance)
        .and_call_original
      instance = subject.instance('i-1abc1234')
      expect(instance).to be_instance_of Aws::EC2::Instance
    end
  end

  context '#wait_until' do
    it 'wait until the instance is ready' do
      expect(subject.client).to receive(:wait_until)
      subject.wait_until(:instance_running, instance_ids: ['i-1abc1234'])
    end
  end

  context '#describe_instance_status' do
    it 'describe the status of an instance' do
      expect(subject.client).to receive(:describe_instance_status)
      subject.describe_instance_status('i-1abc1234')
    end
  end
end

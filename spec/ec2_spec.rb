require 'spec_helper'

RSpec.describe Bitnami::Ec2 do
  before(:all) do
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

  context 'bitnami_security_group' do
    before(:all) do
      aws_stub_security_group
    end

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

        expect(security_group.group_id).to eq 'sg-d76624ba'
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
end

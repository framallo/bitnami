require 'aws-sdk'

module Bitnami
  # Ec2 API wrapper
  class Ec2
    attr_accessor :group_name, :region

    def credentials
      @credentials ||= ::Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def resource
      @resource ||= ::Aws::EC2::Resource.new(
        region: region,
        credentials: credentials)
    end

    def bitnami_security_group
      @security_group ||= (
        find_bitnami_security_group || create_bitnami_security_group)
    end

    def find_bitnami_security_group
      resource.security_groups.find { |s| s.group_name == group_name }
    end

    def create_bitnami_security_group
      security_group = resource.create_security_group(
        group_name: group_name,
        description: 'default security group for wordpress instances')
      security_group.authorize_ingress(
        ip_permissions: [
          { ip_protocol: 'tcp', from_port: 80, to_port: 80 },
          { ip_protocol: 'tcp', from_port: 22, to_port: 22 }
        ])
      security_group
    end

    def region
      @region ||= 'us-east-1'
    end

    def group_name
      @group_name ||= 'bitnami'
    end

    def instance(id)
      resource.instance(id)
    end

    def create_instance(image_id)
      resource.create_instances(
        image_id: image_id,
        min_count: 1,
        max_count: 1,
        security_group_ids: [bitnami_security_group.id],
        key_name: 'ec2indux'
      ).first
    end

    def wait_until(*args, &block)
      client.wait_until(*args, &block)
    end

    def describe_instance_status(instance_id)
      client.describe_instance_status(instance_ids: [instance_id])
    end

    def client
      resource.client
    end

    # def method_missing(method, *args, &block)
    #   resource.send(method, *args, &block)
    # end
  end
end

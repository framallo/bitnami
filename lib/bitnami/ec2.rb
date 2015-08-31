require 'aws-sdk'

module Bitnami
  # Ec2 API wrapper
  class Ec2
    def credentials
      @credentials ||= ::Aws::Credentials.new(
        ENV['AWS_ACCESS_KEY_ID'],
        ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def resource
      @resource ||= ::Aws::EC2::Resource.new(
        region: 'us-east-1',
        credentials: credentials)
    end

    def bitnami_security_group
      @security_group ||= (
        find_bitnami_security_group || create_bitnami_security_group)
    end

    def find_bitnami_security_group
      resource.security_groups.find { |s| s.group_name == 'bitnami' }
    end

    def create_bitnami_security_group
      security_group = resource.create_security_group(
        group_name: 'bitnami6',
        description: 'default security group to wordpress instances for bitnami app')
      security_group.authorize_ingress(
        ip_permissions: [
          { ip_protocol: 'tcp', from_port: 80, to_port: 80 },
          { ip_protocol: 'tcp', from_port: 22, to_port: 22 }
        ])
      security_group
    end

    def instance(id)
      resource.instance(id)
    end

    def create_instances(*args)
      resource.create_instances(*args)
    end

    # def method_missing(method, *args, &block)
    #   resource.send(method, *args, &block)
    # end
  end
end

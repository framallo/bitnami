module AwsHelper
  def aws_enable
    WebMock.disable!
    Aws.config = {}
  end

  def aws_disable
    WebMock.enable!
  end

  # pp the method in aws-sdk-resources-2.1.17/lib/aws-sdk-resources/request.rb @ line 24 Aws::Resources::Request#call:
  def aws_stub
    Aws.config[:ec2] ||= {}
    Aws.config[:ec2][:stub_responses] ||= {}
    Aws.config[:ec2][:stub_responses]
  end

  def aws_stub_security_group
    aws_stub[:describe_security_groups] = {
      security_groups: [
        { owner_id: '123456789012',
          group_name: 'bitnami',
          group_id: 'sg-d76624ba',
          description: 'default to wordpress instances for bitnami app',
          ip_permissions: [],
          ip_permissions_egress: [] }]
    }
    aws_stub[:create_security_group] = { group_id: 'sg-d76624ba' }
  end
end

RSpec.configure do |config|
  config.include AwsHelper
end

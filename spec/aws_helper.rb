module VerboseRequest
  def call(options)
    pp @method_name
    req = super
    pp req.to_hash
    req
  end
end

module AwsHelper
  def aws_enable
    aws_verbose
    WebMock.disable!
    Aws.config = {}
  end

  def aws_disable
    WebMock.enable!
  end

  def aws_verbose
    puts 'Aws is in verbose mode'
    Aws::Resources::Request.prepend(VerboseRequest)
  end

  # pp the method in aws-sdk-resources-2.1.17/lib/aws-sdk-resources/request.rb @ line 24 Aws::Resources::Request#call:
  def aws_stub
    Aws.config[:stub_responses] ||= true
    Aws.config[:ec2] ||= {}
    Aws.config[:ec2][:stub_responses] ||= {}
    Aws.config[:ec2][:stub_responses]
  end

  def aws_stub_security_group
    aws_stub[:describe_security_groups] = {
      security_groups: [
        { owner_id: '123456789012',
          group_name: 'bitnami',
          group_id: 'group-id',
          description: 'default to wordpress instances for bitnami app',
          ip_permissions: [],
          ip_permissions_egress: [] }]
    }
    aws_stub[:create_security_group] = { group_id: 'group-id' }
  end

  def aws_stub_create
    aws_stub[:run_instances] = {
      reservation_id: 'reservation-id',
      owner_id: '123456789012',
      requester_id: '123456789012',
      groups: [],
      instances: [{
        instance_id: 'i-1abc1234',
        image_id: 'ami-393c8c52',
        state: { code: 16, name: 'running' },
        private_dns_name: 'ip-127-0-0-1.us-east-1.compute.internal',
        public_dns_name: '',
        state_transition_reason: '',
        key_name: 'bitnami',
        ami_launch_index: 0,
        product_codes: [],
        instance_type: 't2.micro' }] }
  end

  def aws_stub_describe_instance_status
    aws_stub[:describe_instance_status] = {
      instance_statuses: [{
        instance_id: 'i-1abc1234',
        availability_zone: 'us-east-1e',
        instance_state:  { code: 0, name: 'pending' },
        system_status:   {
          status: 'not-applicable',
          details: [{
            name: 'reachability', status: 'passed', impaired_since: nil
          }] },
        instance_status: {
          status: 'not-applicable',
          details: [{
            name: 'reachability', status: 'passed', impaired_since: nil
          }] } }]
    }
  end

  def aws_access_key_id
    ENV['AWS_ACCESS_KEY_ID'] || 'AAAAAAAAAAAAAAAAAAAA'
  end

  def aws_secret_access_key
    ENV['AWS_SECRET_ACCESS_KEY'] || '1aA11A/aaAAAaAAaaAAaaaa1aaAa1aaa1AAaaa11'
  end
end

RSpec.configure do |config|
  config.include AwsHelper
end

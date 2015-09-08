module Bitnami
  # bitnami Wordpress instance
  class Wordpress
    Status = Struct.new(
      :system_status, :instance_status, :state_name, :state_code)

    attr_accessor :instance, :id

    def initialize(aws_access_key_id, aws_secret_access_key, id = nil)
      @id = id
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
    end

    def create
      return if @id
      @instance ||= ec2.create_instance(image_id)
    end

    def ec2
      @ec2 ||= Ec2.new(@aws_access_key_id, @aws_secret_access_key)
    end

    def id
      @id ||= (instance.id if instance)
    end

    def find
      @instance ||= (ec2.instance(id) if id)
    end

    def image_id
      bitnami_amis[ec2.region]
    end

    def bitnami_amis
      { 'us-east-1' => 'ami-393c8c52' }
    end

    def status
      return unless id
      @status ||= fetch_status
    end

    def fetch_status
      r = ec2.describe_instance_status(id).instance_statuses[0]

      Status.new(
        r.system_status.details[0].try(:status),
        r.instance_status.details[0].try(:status),
        r.instance_state.name,
        r.instance_state.code
      )
    end
  end
end

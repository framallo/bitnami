module Bitnami
  # bitnami Wordpress instance
  class Wordpress
    Status = Struct.new(
      :system_status, :instance_status, :state_name, :state_code)

    attr_accessor :instance, :id

    def initialize(id = nil)
      @id = id
    end

    def create
      return if @id
      @instance ||= ec2.create_instance(image_id)
    end

    def ec2
      @ec2 ||= Ec2.new
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

      r = ec2.describe_instance_status(id).instance_statuses[0]
      system_status = r.system_status.details[0]
      instance_status = r.instance_status.details[0]

      Status.new(
        (system_status.status if system_status),
        (instance_status.status if instance_status),
        r.instance_state.name,
        r.instance_state.code
      )
    end
  end
end

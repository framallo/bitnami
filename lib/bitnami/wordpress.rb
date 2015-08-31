module Bitnami
  # bitnami Wordpress instance
  class Wordpress
    attr_accessor :instance, :id

    def initialize(id = nil)
      @id = id
      # find(instance_id) if instance_id
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

    def image_id
      bitnami_amis[ec2.region]
    end

    def bitnami_amis
      { 'us-east-1' => 'ami-393c8c52' }
    end
  end
end

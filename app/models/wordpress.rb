require 'bitnami'

class Wordpress < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  after_create :create_instance

  def create_instance
    CreateInstanceWorker.perform_async(id) if id
  end

  def actually_create_instance
    return if instance_id
    instance.create
    self.instance_id = instance.id
    save!
  end

  def fetch_status
    WordpressStatusWorker.perform_async(id)
  end

  def actually_fetch_status
    self.status = instance.status.state
    save!
  end

  def instance
    @instance ||= Bitnami::Wordpress.new(instance_id)
  end
end

require 'bitnami'

class Wordpress < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  validate :user_must_have_credentials
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
    self.status = instance.status.system_status
    save!
  end

  def instance
    @instance ||= Bitnami::Wordpress.new(
      user.aws_access_key_id, user.aws_secret_access_key, instance_id)
  end

  def user_must_have_credentials
    user && user.aws_access_key_id? && user.aws_secret_access_key?
  end
end

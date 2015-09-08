require 'sidekiq'

class CreateInstanceWorker
  include Sidekiq::Worker

  def perform(wordpress_id)
    Wordpress.find(wordpress_id).actually_create_instance
  end
end

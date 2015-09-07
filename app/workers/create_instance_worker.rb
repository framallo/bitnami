require 'sidekiq'

class CreateInstanceWorker
  include Sidekiq::Worker

  def perform(wordpress_id)
    puts "CreateInstanceWorker #{wordpress_id}"
    Wordpress.find(wordpress_id).actually_create_instance
    puts
  end
end

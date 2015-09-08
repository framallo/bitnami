require 'sidekiq'

class WordpressStatusWorker
  include Sidekiq::Worker

  attr_accessor :delay

  def perform(id, attempts = 1)
    delay = (Time.now + 5)
    max_attempts = 40
    continue = attempts < max_attempts

    Wordpress.find(id).actually_fetch_status

    self.class.perform_in(delay, id, attempts + 1) if continue
  end
end

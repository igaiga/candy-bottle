# -*- coding: utf-8 -*-
class Tweet
  attr_reader :stream, :client
  def initialize
    config = Pit.get("candy-bottle", require: {
                       twitter: {
                         consumer_key: 'consumer_key',
                         consumer_secret: 'consumer_secret',
                         access_token: 'access_token',
                         access_token_secret: 'access_token_secret' }
                     })

    # @client = Twitter::Client.new do |twitter_config|
    #   twitter_config.consumer_key = config[:twitter][:consumer_key]
    #   twitter_config.consumer_secret = config[:twitter][:consumer_secret]
    #   twitter_config.access_token = config[:twitter][:access_token]
    #   twitter_config.access_token_secret = config[:twitter][:access_token_secret]
    # end

    # streaming api
    @stream = Twitter::Streaming::Client.new do |twitter_config|
      twitter_config.consumer_key = config[:twitter][:consumer_key]
      twitter_config.consumer_secret = config[:twitter][:consumer_secret]
      twitter_config.access_token = config[:twitter][:access_token]
      twitter_config.access_token_secret = config[:twitter][:access_token_secret]
    end

    @targets = Target.pluck(:word).to_a
  end

  def self.bring
    @tweet  = Tweet.new
    # temporary comment out
    # loop do
      begin
        @tweet.bring
      rescue Exception => e
        Rails.logger.error "Exception occur : #{e}"
      end
    # end
  end

  def bring
    @stream.user do |obj|
      case obj
      when Twitter::Tweet
        if @targets.any? { |word| obj.text.include?(word) }
          p "#{obj.id} : #{obj.text}, #{obj.user.user_name}, #{obj.user.name}, #{obj.user.id}"
        end
      end
    end
  end
end

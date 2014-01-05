# -*- coding: utf-8 -*-
# $ RAILS_ENV=production ber runner "TweetCollector.bring"
class TweetCollector
  attr_reader :stream
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
    @pusher = Pusher.new
  end

  def self.bring
    @collector  = self.new
    loop do
      begin
        @collector.bring
      rescue Exception => e
        # TODO ログに日時を出したい
        Rails.logger.error "Exception occur in TweetCollector: #{e}"
      end
    end
  end

  def bring
    @stream.user do |obj|
      case obj
      when Twitter::Tweet
        Tweet.create(user_account: obj.user.user_name, user_name: obj.user.name, user_id: obj.user.id, text: obj.text, status_id: obj.id)

        if @targets.any? { |word| obj.text.include?(word) }
          @pusher.push "@#{obj.user.user_name} (#{obj.user.name}) : #{obj.text} : #{obj.id}"
          # TODO : twitter へリンク貼るとか、twitterアプリへ飛ばすとか、連携を考えたい
          p "@#{obj.user.user_name} (#{obj.user.name}) : #{obj.text} : #{obj.id} : #{obj.user.id}"
        end
      end
    end
  end
end

class Tweet
  def self.bring
    config = Pit.get("candy-bottle", require: {
                       twitter: {
                         consumer_key: 'consumer_key',
                         consumer_secret: 'consumer_secret',
                         access_token: 'access_token',
                         access_token_secret: 'access_token_secret' }
                     })

    client = Twitter::Streaming::Client.new do |twitter_config|
      twitter_config.consumer_key= config[:twitter][:consumer_key]
      twitter_config.consumer_secret= config[:twitter][:consumer_secret]
      twitter_config.access_token= config[:twitter][:access_token]
      twitter_config.access_token_secret= config[:twitter][:access_token_secret]
    end
    client.sample do |t|
    end
  end
end

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

    @client = Twitter::Client.new do |twitter_config|
      twitter_config.consumer_key = config[:twitter][:consumer_key]
      twitter_config.consumer_secret = config[:twitter][:consumer_secret]
      twitter_config.access_token = config[:twitter][:access_token]
      twitter_config.access_token_secret = config[:twitter][:access_token_secret]
    end

    # streaming api
    @stream = Twitter::Streaming::Client.new do |twitter_config|
      twitter_config.consumer_key = config[:twitter][:consumer_key]
      twitter_config.consumer_secret = config[:twitter][:consumer_secret]
      twitter_config.access_token = config[:twitter][:access_token]
      twitter_config.access_token_secret = config[:twitter][:access_token_secret]
    end
  end

  def bring
    @stream.user do |obj|
      case obj
      when Twitter::Tweet
        p "#{ obj.id } : #{obj.text},#{obj.user.name}, #{obj.user.id}"
      when Twitter::DirectMessage
        #puts "It's a direct message!"
      when Twitter::Streaming::StallWarning
        #warn "Falling behind!"
      end
    end
  end
end

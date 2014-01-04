class Pusher
  def initialize
    config = Pit.get("im-kayac", require: { user: 'user', password: 'pass' })
    @user = config[:user]
    @password = config[:password]
  end

  def push(message)
    begin
      p ImKayac.to(@user).password(@password).post(message)
    rescue Exception => e
      Rails.logger.error "im-kayac error occured. : #{e}"
    end
  end
end

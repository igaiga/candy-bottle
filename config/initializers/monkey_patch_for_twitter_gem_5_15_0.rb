# Monkey-patch HTTP::URI
# Resolve to twitter gem the follow problem.
# https://github.com/sferik/twitter/issues/709
class HTTP::URI
  def port
    443 if self.https?
  end
end

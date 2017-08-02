require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req.cookies
    @cookie = req.cookies["_rails_lite_app"]
    @cookie ? @data = JSON.parse(@cookie) : @data = {}
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie("_rails_lite_app", {path: '/', value: res.to_json})
  end
end

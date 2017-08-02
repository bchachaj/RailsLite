require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req.cookies
    cookie = req.cookies["_rails_lite_app"]
    @data = cookie ? JSON.parse(cookie) : {}
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
    json_data = @data.to_json
    res.set_cookie("_rails_lite_app", {path: '/', value: json_data})
  end
end

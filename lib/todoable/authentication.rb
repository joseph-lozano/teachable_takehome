require "net/http"
require "uri"

class Todoable::Authentication
  AUTH_URI = URI("https://todoable.teachable.tech/api/authenticate")
  attr_reader :token

  def self.fetch_token()
    headers = { "Content-Type" => "application/json", "Accept" => "application/json" }
    post_req = Net::HTTP::Post.new(AUTH_URI)
    username = Todoable.configuration.username
    password = Todoable.configuration.password
    post_req.basic_auth(username, password)
    resp = Net::HTTP.start(AUTH_URI) do |http|
      http.request(post_req)
    end
    raise AuthenticationError unless resp.code == "200"
    @@token = JSON.parse(resp.body)["token"]
    @@token
  end

  def self.token
    @@token
  end
end

class AuthenticationError < StandardError
end

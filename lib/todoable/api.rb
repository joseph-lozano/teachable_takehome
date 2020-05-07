require "net/http"

class Todoable::API
  BASE_PATH = "https://todoable.teachable.tech/api/"
  INDEX_PATH = "lists"
  def self.index
    token = Todoable::Authentication.token()
    uri = URI(BASE_PATH + INDEX_PATH)
    request = Net::HTTP::Get.new(uri.path)
    request["Authorization"] = "Token token=\"#{token}\""
    res = Net::HTTP.start(uri.host, use_ssl: true) do |http|
      http.request(request)
    end
    JSON.parse(res.body)
  end

  def self.show(list_id)
    token = Todoable::Authentication.token()
    uri = URI(BASE_PATH + "lists/#{list_id}")
    request = Net::HTTP::Get.new(uri.path)
    request["Authorization"] = "Token token=\"#{token}\""
    res = Net::HTTP.start(uri.host, use_ssl: true) do |http|
      http.request(request)
    end
    JSON.parse(res.body)
  end

  def self.create(list_name)
    token = Todoable::Authentication.token()
    uri = URI(BASE_PATH + "lists")
    data = {
      "list": {
        "name": list_name,
      },
    }
    request = Net::HTTP::Post.new(uri.path)
    request["Authorization"] = "Token token=\"#{token}\""
    request.body = data.to_json
    res = Net::HTTP.start(uri.host, use_ssl: true) do |http|
      http.request(request)
    end
    true
  end
end

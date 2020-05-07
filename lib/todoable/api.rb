require "net/http"

class Todoable::API
  BASE_PATH = "https://todoable.teachable.tech/api/"
  INDEX_PATH = "lists"
  def self.index
    uri = URI(BASE_PATH + INDEX_PATH)
    get(uri)
  end

  def self.show_list(list_id)
    token = Todoable::Authentication.token()
    uri = URI(BASE_PATH + "lists/#{list_id}")
    get(uri)
  end

  def self.create_list(list_name)
    token = Todoable::Authentication.token()
    uri = URI(BASE_PATH + "lists")
    data = {
      "list": {
        "name": list_name,
      },
    }
    post(uri, data)
  end

  def self.update_list_name(list_id, list_name)
    token = Todoable::Authentication.token()
    uri = URI(BASE_PATH + "lists/#{list_id}")
    data = {
      "list": {
        "name": list_name,
      },
    }
    patch(uri, data)
  end

  def self.delete_list(list_id)
    uri = URI(BASE_PATH + "lists/#{list_id}")
    delete(uri)
  end

  private

  def self.get(uri)
    request = Net::HTTP::Get.new(uri.path)
    res = make_request(uri, request)
    JSON.parse(res.body)
  end

  def self.post(uri, data = nil)
    request = Net::HTTP::Post.new(uri.path)
    request.body = data.to_json unless data.nil?
    make_request(uri, request)
    true
  end

  def self.patch(uri, data = nil)
    request = Net::HTTP::Patch.new(uri.path)
    request.body = data.to_json unless data.nil?
    make_request(uri, request)
    true
  end

  def self.delete(uri)
    request = Net::HTTP::Delete.new(uri.path)
    res = make_request(uri, request)
    true
  end

  def self.make_request(uri, request)
    token = Todoable::Authentication.token()
    request["Authorization"] = "Token token=\"#{token}\""
    res = Net::HTTP.start(uri.host, use_ssl: true) do |http|
      http.request(request)
    end
  end
end

require "todoable/version"
require "todoable/api"
require "todoable/authentication"
require "todoable/configuration"

module Todoable
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

  def self.init(username, password)
    Todoable.configure do |config|
      config.username = username
      config.password = password
    end
    Todoable::Authentication.fetch_token()
  end

  def self.list_lists()
    Todoable::API.index()
  end

  def self.create_list(name)
    Todoable::API.create_list(name)
  end

  def self.get_list(id)
    Todoable::API.show_list(id)
  end

  def self.update_list(id, name: new_name)
    Todoable::API.update_list_name(id, new_name)
  end

  def self.delete_list(id)
    Todoable::API.delete_list(id)
  end

  def self.create_item(list_id, item_name)
    Todoable::API.create_item(list_id, item_name)
  end
end

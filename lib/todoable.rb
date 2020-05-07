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

  def self.hello
    "Hello World"
  end

  def self.init(username, password)
    Todoable.configure do |config|
      config.username = username
      config.password = password
    end
    Todoable::Authentication.fetch_token()
  end

  def self.index()
    Todoable::API.index()
  end
end

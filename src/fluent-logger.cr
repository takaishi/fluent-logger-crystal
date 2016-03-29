require "./fluent-logger/*"

require "socket"
require "json"
require "msgpack"

module Fluent
  class Logger
    @@logger : Fluent::Logger::FluentLogger | Nil

    def initialize(tag_prefix, host = "localhost", port = 24224)
      @tag_prefix = tag_prefix
      @host = host
      @port = port
    end

    def self.open(tag_prefix, host = "localhost", port = 24224)
      @@logger = Fluent::Logger::FluentLogger.new(tag_prefix, host, port)
    end

    def self.post(tag, map)
      @@logger.try do |logger|
        logger.post(tag, map)
      end
    end
  end
end

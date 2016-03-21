require "./fluent-logger-crystal/*"

require "socket"
require "json"
require "msgpack"

module Fluent::Logger
  class FluentLogger
    def initialize(tag_prefix, host = "localhost", port = 24224)
      @tag_prefix = tag_prefix
      @host = host
      @port = port
    end

    def post(tag, map)
      time = Time.now
      write [tag, time.epoch, map]
    end

    def write(msg)
      p msg
      puts msg.to_json
      p msg.to_json.to_msgpack
      conn = TCPSocket.new(@host, @port)
      conn.write(msg.to_msgpack)
    end
  end
end

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
      begin
        time = Time.now
        write ["#{@tag_prefix}.#{tag}", time.epoch, map]
      rescue ex
        set_last_error(ex)
        false
      end
    end

    def write(msg)
      conn = TCPSocket.new(@host, @port)
      conn.write(msg.to_msgpack)
      true
    end

    def set_last_error(e)
      @last_error = e
    end

    def last_error
      @last_error
    end
  end
end

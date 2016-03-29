require "./spec_helper"
require "json"
require "msgpack"
require "spec2"

include Spec2::GlobalDSL

struct Time
  def self.now
    # epoch time(UTC): 921974400
    Time.new(1999, 3, 21, 0, 0, 0, 0, Time::Kind::Utc)
  end
end

alias TestType = Array(String | Float32 | Float64 | UInt16 | UInt32 | UInt64 | UInt8 | Int16 | Int32 | Int64 | Int8 | Hash(MessagePack::Type, MessagePack::Type))

class MockServer
  def initialize(ch)
    @ch = ch
    @server = TCPServer.new("localhost", 1234)
  end

  def start
    spawn do
      resp = TestType.new
      socket = @server.accept
      unpacker = MessagePack::Unpacker.new(socket)
      i = 0

      unpacker.read_array do
        case i
        when 0
          resp << unpacker.read_string
        when 1
          resp << unpacker.read_numeric
        when 2
          h = {} of String => String
          resp << unpacker.read_hash
        end
        i += 1
      end
      socket.close
      @ch.send(resp)
    end
  end

  def stop
    @server.close
  end
end

describe Fluent::Logger::FluentLogger do
  let(ch) { Channel(TestType).new }
  let(mock_server) { MockServer.new(ch) }

  before do
    mock_server.start
  end

  after do
    mock_server.stop
  end

  describe "simple" do
    let(logger) { Fluent::Logger::FluentLogger.new(nil, "localhost", 1234) }

    it "success" do
      expect(logger.post("myapp.access", {"foo": "bar"})).to be_truthy
      expect(ch.receive).to eq(["myapp.access", 921974400, {"foo": "bar"}])
    end
  end

  describe "singleton" do
    before { Fluent::Logger::FluentLogger.open(nil, "localhost", 1234) }

    it "success" do
      expect(Fluent::Logger.post("myapp.access", {"foo": "bar"})).to be_truthy
      expect(ch.receive).to eq(["myapp.access", 921974400, {"foo": "bar"}])
    end
  end

  describe "tag_prefix" do
    let(logger) { Fluent::Logger::FluentLogger.new("myapp", "localhost", 1234) }

    it "success" do
      expect(logger.post("access", {"foo": "bar"})).to be_truthy
      expect(ch.receive).to eq(["myapp.access", 921974400, {"foo": "bar"}])
    end
  end
end

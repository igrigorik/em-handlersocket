require 'eventmachine'
require 'em/protocols/line_protocol'
require 'em-handlersocket/client'

module EventMachine
  module HandlerSocket
    def self.new(options = {})
      opt = {
        :host => '127.0.0.1',
        :port => '9998'
      }.merge(options)

      EventMachine.connect(opt[:host], opt[:port], EventMachine::HandlerSocket::Client)
    end
  end
end

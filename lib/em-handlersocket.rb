require 'eventmachine'
require 'em-handlersocket/client'

module EventMachine
  module HandlerSocket
    def self.new(opt = {})
      EventMachine.connect(opt[:host], opt[:port], EventMachine::HandlerSocket::Client)
    end
  end
end

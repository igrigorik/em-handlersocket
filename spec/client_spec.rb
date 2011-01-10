require 'helper'

describe EventMachine::HandlerSocket do

  it "should connect to HandlerSocket server" do
    EM.run {
      c = EM::HandlerSocket.new(:host => '127.0.0.1', :port => '9998')
      c.class.should == EventMachine::HandlerSocket::Client

      EM.stop
    }
  end

end

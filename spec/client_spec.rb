require 'helper'

describe EventMachine::HandlerSocket do

  it "should connect to HandlerSocket server" do
    EM.run {
      c = EM::HandlerSocket.new(:host => '127.0.0.1', :port => '9998')
      c.class.should == EventMachine::HandlerSocket::Client

      EM.stop
    }
  end

  it "should connect to localhost, read-only port by default" do
    EM.run {
      c = EM::HandlerSocket.new
      c.class.should == EventMachine::HandlerSocket::Client

      EM.stop
    }
  end

  it "should open an index via raw interface" do
    EM.run {
      c = EM::HandlerSocket.new

      df = c.execute(['P', '0', 'widgets', 'user', 'PRIMARY', 'user_name,user_email,created'])
      df.callback {|r|
        r.should == ["0", "1"]
        EM.stop
      }
    }
  end

  it "should open an index" do
    EM.run {
      c = EM::HandlerSocket.new
      d = c.open_index({
                         :id => 0,
                         :db => 'widgets',
                         :table => 'user',
                         :index_name => 'PRIMARY',
                         :columns => 'user_name,user_email,created'
      })

      d.callback do
        EM.stop
      end
    }

    # df = c.execute(['0', '=',  '1', '1'])
    # df.callback { |data|
    #   p data
    #   EM.stop
    # }


  end
end

require 'helper'

#
# create database widgets;
# CREATE TABLE user (
#   user_id INT UNSIGNED PRIMARY KEY,
#   user_name VARCHAR(50),
#   user_email VARCHAR(255),
#   created DATETIME
# ) ENGINE=InnoDB;
#
# insert into user (user_id, user_name, user_email, created) values (1, 'Ilya', 'ilya@igvita.com', '2010-01-01');
# insert into user (user_id, user_name, user_email, created) values (2, 'John', 'john@example.com', '2010-01-02');
# insert into user (user_id, user_name, user_email, created) values (3, 'Bob', 'bob@example.com', '2010-01-03');
#

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
        r.should == ['0', '1']
        EM.stop
      }
    }
  end

  it "should open an index" do
    EM.run {
      c = EM::HandlerSocket.new
      idx = {:id => 0, :db => 'widgets', :table => 'user', :index_name => 'PRIMARY', :columns => 'user_name'}

      d = c.open_index(idx)
      d.callback do
        EM.stop
      end
    }
  end

  it "should fetch a single record" do
    EM.run {
      c = EM::HandlerSocket.new
      idx = {:id => 0, :db => 'widgets', :table => 'user', :index_name => 'PRIMARY', :columns => 'user_name'}

      d = c.open_index(idx)
      d.callback do |s|

        d = c.query(:id => 0, :op => '=', :key => '1')
        d.callback do |data|
          data.last.should == 'Ilya'
          EM.stop
        end
      end
    }
  end

  it "should fetch multiple records" do
    pending("trickier one.. response is returned on multiple lines, requires DF accounting")

    EM.run {
      c = EM::HandlerSocket.new
      idx = {:id => 0, :db => 'widgets', :table => 'user', :index_name => 'PRIMARY', :columns => 'user_name'}

      d = c.open_index(idx)
      d.callback do |s|

        d = c.query({:id => 0, :op => '=', :key => '1'}, {:id => 0, :op => '=', :key => '2'})
        d.callback do |data|
          p data
          EM.stop
        end
      end
    }
  end


end

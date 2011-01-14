# EM-HandlerSocket

EventMachine client for HandlerSocket MySQL plugin for direct read/write of InnoDB tables. This plugin bypasses any/all SQL parsing, query planner, and other MySQL locks, while giving you the advantage of InnoDB persistence, speed, and the network daemon! Best of all, HandlerSocket plugin runs alongside your regular MySQL engine, which means you still have the full advantage of a SQL console at your disposal.

[HandlerSocket: The NoSQL MySQL & Ruby](http://www.igvita.com/2011/01/14/handlersocket-the-nosql-mysql-ruby/)

## Features

- Plays nicely with the (EventMachine) reactor
- No native extensions
- Pipelined processing

## Example: Open & Read from an InnoDB index

Open the PRIMARY key index on the widgets.user InnoDB table, and query for id == 1.

    EM.run {
      c = EM::HandlerSocket.new
      idx = {:id => 0, :db => 'widgets', :table => 'user', :index_name => 'PRIMARY', :columns => 'user_name'}

      d = c.open_index(idx)
      d.callback do

        d = c.query(:id => 0, :op => '=', :key => '1')
        d.errback { p 'uh oh!' }
        d.callback do |data|
          p ["received data", data]
        end
      end
    }

## Todo

- Add support for insert/update/delete

## Resources

- [HandlerSocket Protocol](https://github.com/ahiguti/HandlerSocket-Plugin-for-MySQL/blob/master/docs-en/protocol.en.txt)
- [HandlerSocket @ DeNA](http://yoshinorimatsunobu.blogspot.com/2010/10/using-mysql-as-nosql-story-for.html)

# License

(The MIT License)
Copyright © 2011 Ilya Grigorik
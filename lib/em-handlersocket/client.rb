module EventMachine
  module HandlerSocket

    class Deferrable < EM::DefaultDeferrable
      attr_accessor :lines, :buffer

      def initialize(lines)
        @lines = lines
        @buffer = []
      end

      def recieve(line)
        status, cols, data = line.chomp.split("\t")
        @buffer.push data

        # non-zero response code indicates error
        if status.to_i != 0
          fail
          return true
        end

        done?
      end

      # non zero response code, or we've processed all lines
      def done?; (@buffer.size == @lines); end

      def succeed
        super(@buffer)
      end
    end

    class Client < EventMachine::Connection
      include EventMachine::Deferrable
      include EventMachine::Protocols::LineProtocol

      def initialize
        @deferrables = []
      end

      def connection_completed
        succeed
      end

      def open_index(opts)
        execute([['P', opts[:id], opts[:db], opts[:table], opts[:index_name], opts[:columns]]])
      end

      def query(*queries)
        execute(queries.map{|q| [q[:id], q[:op], q[:key].size, q[:key], q[:limit], q[:offset]].compact })
      end

      def insert(opts)
        execute([[opts[:id], '+', opts[:data].size, opts[:data]]])
      end

      def execute(cmd, &blk)
        callback { send(cmd) }
        add_deferrable(cmd.size, &blk)
      end

      private

        def send(data)
          send_data data.map {|d| d.join("\t")}.join("\n") + "\n"
        end

        def receive_line(line)
          if @deferrables.first.recieve(line)
            @deferrables.shift.succeed
          end
        end

        def add_deferrable(lines, &blk)
          df = Deferrable.new(lines)
          df.callback &blk

          @deferrables.push(df)
          df
        end

    end
  end
end
module EventMachine
  module HandlerSocket
    class Client < EventMachine::Connection

      include EventMachine::Deferrable
      include EventMachine::Protocols::LineProtocol

      def initialize
        @deferrables = []
      end

      def connection_completed
        succeed
      end

      def execute(*cmd, &blk)
        callback { send(cmd) }
        add_deferrable(&blk)
      end

      def open_index(opts)
        execute(['P', opts[:id], opts[:database], opts[:table], opts[:index_name], opts[:columns]])
      end

      # def query(*q)
      # end

      private

        def send(data)
          send_data data.join("\t") + "\n"
        end

        def receive_line(line)
          @deferrables.shift.succeed(line.chomp.split("\t"))
        end

        def add_deferrable(&blk)
          df = EM::DefaultDeferrable.new
          df.callback &blk

          @deferrables.push(df)
          df
        end

    end
  end
end
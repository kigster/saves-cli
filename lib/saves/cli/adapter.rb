module Saves
  module CLI
    class Adapter
      attr_accessor :app, :options, :client

      def initialize(app, client)
        self.app     = app
        self.options = app.options
        self.client  = client
      end

      def [](value)
        options[value]
      end

      def exec
        client.saves_base_url = self[:saves_base_url] if self[:saves_base_url]

        if self[:verbose]
          log("SavesService Location: #{self.saves_base_url}")
          log("calling operation #{app.command.to_s.bold.blue} with #{options.to_h.inspect.bold.green}")
        end
        result = call_service(app)
        log("return result is #{result.attributes.inspect.bold.green}") if self[:verbose]
        output_result result
      rescue SavesClient::HTTPError => e
        printf "Error executing command #{app.command.to_s.bold.yellow}:\n"
        printf ' → '.red + e.message.gsub(/encountered a /, "encountered a\n → ").bold.italic.red
        puts
      end

      # Supported Operations

      def encode
        SavesClient::Models::FakeSave.new(options).composite_id
      end

      def decode
        SavesClient::Models::FakeSave.decode_composite_id(options[:save])
      end

      def fetch
        save = canonical_save_id(options)
        client.by_id(save).first || { error: "Save with parameters #{options.delete(:created_at); options.to_h.inspect.bold.blue} was not found." }
      end

      private

      def call_service(app)
        result = if self.respond_to?(app.command)
                   self.send(app.command)
                 else
                   client.send(app.command, options)
                 end
        return { error: 'Service returned nil' } if result.nil?
        result.respond_to?(:attributes) ? result.attributes.to_hash : result
      end


      def canonical_save_id(options)
        save = options[:save]
        unless save
          save = encode
        end
        save
      end

      def output_result(result)
        result = result.to_hash if result.respond_to?(:to_hash)
        case result
          when String
            puts result.bold.yellow
          when Hash
            if result[:error]
              puts 'Error occured: '.bold.red
              printf " →  #{result[:error]}\n\n"
            else
              result.stringify_keys!
              ap result
            end
          else
            puts "Warning: #{'Unknown result type'.bold.yellow}:\n"
            puts result.inspect.bold.blue
        end
      end

      def log(*args, &block)
        level = if args.first.is_a?(Symbol)
                  args.shift
                else
                  :info
                end
        Saves::CLI.logger.send(level, *args, &block)
      end
    end
  end
end

require 'optparse'
require 'saves/cli/client'
require 'hashie/mash'
require 'colored2'

module Saves
  module CLI
    class InvalidCommandError < ArgumentError;
    end
    class Parser < OptionParser

      @options = Hashie::Mash.new
      @output  = Array.new

      class << self
        attr_accessor :options, :output

        def global
          @global ||= ::Saves::CLI::Parser.new do |parser|
            parser.banner = usage_line
            parser.sep
            parser.on('-v', '--[no-]verbose', 'run verbosely') {|v| options[:verbose] = v}
            parser.option_help(commands: true)
          end
        end

        def usage_line(command = nil)
          command ?
            'Usage: ' + 'saves-cli '.bold.blue + command.bold.green + ' [options]'.yellow :
            'Usage: ' + 'saves-cli '.bold.blue + '[options] '.yellow + '[' + (command || 'command').green + ' [options]'.yellow + ']'
        end

        def commands
          @commands ||= {
            create: {
              description: 'a new save using the provided data',
              parser:      ::Saves::CLI::Parser.new do |parser|
                parser.banner = usage_line 'create'
                parser.option_url
                parser.option_user_product_collection
                parser.option_help
              end
            },

            fetch:  {
              description: 'an existing save by its identifier',
              parser:      ::Saves::CLI::Parser.new do |parser|
                parser.banner = usage_line 'fetch'
                parser.option_url
                parser.option_save
                parser.option_help
              end,
            }
          }
        end

        def parser_for(cmd)
          if commands[cmd]
            commands[cmd][:parser]
          else
            raise(InvalidCommandError, "'#{cmd}' is not a valid command.\nSupported commands are:\n\t#{commands.keys.join("\n\t")}")
          end
        end
      end

      #
      # Instance Methods
      #

      def sep(text = nil)
        separator text || ''
      end

      def option_save
        on('-sSAVE', '--save SAVE', "three-part save, eg. 'f3-32r-e3'") {|v| options[:save] = v}
      end

      def option_url
        on('-bURL', '--base-url URL', 'saves service base URL', 'defaults to ' + Client::DEFAULT_BASE_URL) {|v| options[:saves_base_url] = v}
      end

      def option_help(commands: false)
        on('-h', '--help', 'prints this help') do
          output_help
          output_command_help if commands
        end
      end

      def option_user_product_collection
        on('-uUSER', '--user USER', 'user ID') {|v| options[:user_id] = v}
        on('-pPRODUCT', '--product PRODUCT', 'product ID') {|v| options[:product_id] = v}
        on('-cCOLLECTION', '--collection COLLECTION', 'collection ID') {|v| options[:collection_id] = v}
      end

      def option_help_with_subtext
        option_help
      end

      def output_help
        output self.to_s
      end

      def output_command_help
        output command_help
      end

      def options
        self.class.options
      end

      def command_help
        subtext = "  Available Commands:\n"

        self.class.commands.each_pair do |command, config|
          subtext << <<-EOS
#{sprintf('%12s', command.to_s).bold.green} : #{sprintf('%-70s', config[:description]).bold.yellow}
          EOS
        end

        subtext << <<-EOS
        
  See #{'saves-cli '.bold.blue + '<command> '.bold.green + '--help'.bold.yellow} for more information on a specific command.

        EOS

        subtext
      end

      def output(value = nil)
        self.class.output << value if value
        self.class.output
      end

    end
  end
end

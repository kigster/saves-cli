require 'colored2'
require 'optparse'
require 'hashie/mash'
require 'saves/cli/parser'

module Saves
  module CLI
    class App
      class << self
        attr_accessor :parser, :stdout_array, :stderr_array
      end

      # Lines/blocks of text
      self.stdout_array = []
      self.stderr_array = []

      self.parser              = ::Saves::CLI::Parser
      self.parser.stdout_array = self.stdout_array

      attr_accessor :argv, :stdin, :stdout, :stderr, :kernel
      attr_accessor :command, :options

      def initialize(argv, stdin=STDIN, stdout=STDOUT, stderr=STDERR, kernel=Kernel)
        self.stdin  = stdin
        self.stdout = stdout
        self.stderr = stderr
        self.kernel = kernel

        if argv.nil? || argv.empty?
          self.argv = %w[--help]
        else
          self.argv = argv.dup
        end

        self.options = parser.options
      end

      def parse!
        if argv.first =~ /^[a-zA-Z]+/
          cmd = self.argv.shift.to_sym
          parse_options {
            Parser.parser_for(cmd).parse!(argv)
            self.command = cmd # did not raise exception, so valid command.
            if argv && !argv.empty?
              Parser.global.parse!(argv)
            end
          }
        else
          parse_options {parser.global.parse!(argv)}
        end

        process_options!
        print_output
      end

      def process_options!
        Saves::CLI.logger = ::Logger.new(STDOUT) if options[:verbose]
      end

      def print_output
        print_if_have_contents(self.stderr, self.class.stderr_array) || print_if_have_contents(self.stdout, self.class.stdout_array)
      end

      def out
        self.class.stdout_array.join("\n")
      end

      def print_if_have_contents(stream, array)
        unless array.empty?
          stream.printf array.join("\n") + "\n\n"
          true
        else
          false
        end
      end

      def parse_options(&block)
        begin
          block.call
        rescue Saves::CLI::InvalidCommandError => e
          self.class.stderr_array << e.message.capitalize.bold.red
          logger.error(e.message)
        rescue OptionParser::ParseError => e
          if e.message =~ /:/
            title, option = e.message.split(/:/)
            str           ="Oh vey, #{title.capitalize}".bold.yellow + ': ' + option.bold.red
            self.class.stderr_array << str
          else
            self.class.stderr_array << e.message.bold.red
          end
          logger.error(e.message)
        end
      end

      def parser
        self.class.parser
      end

      private

      def logger
        Saves::CLI.logger || Hashie::Mash.new
      end


    end
  end
end

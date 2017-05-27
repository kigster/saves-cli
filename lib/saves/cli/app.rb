require 'colored2'
require 'optparse'
require 'hashie/mash'
require 'saves/cli/parser'
require 'saves/cli/client'
require 'pp'

module Saves
  module CLI
    class App
      class << self
        attr_accessor :parser, :stdout_array, :stderr_array
      end

      # Lines/blocks of text
      self.stdout_array = Array.new
      self.stderr_array = Array.new
      self.parser       = ::Saves::CLI::Parser.tap { |parser| parser.stdout_array = self.stdout_array }

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


      def run!
        Saves::CLI.logger = ::Logger.new(STDOUT) if options[:verbose]

        if command
          Saves::CLI::Client.exec(self)
        else
          flush
        end
      end


      def parse!
        global_argv = []
        while argv && !argv.empty? && argv.first.start_with?('-') do
          global_argv << argv.shift
        end

        parse_options { parser.global.parse!(global_argv) }

        if argv && !argv.empty? && !argv.first.start_with?('-')
          cmd = argv.shift.to_sym
          parse_options do
            parser.parser_for(cmd).parse!(argv)
            flush || self.command = cmd # did not raise exception, so valid command.
          end
        end

        self
      end

      def parser
        self.class.parser
      end

      private

      def logger
        Saves::CLI.logger || Hashie::Mash.new
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

      def print_if_have_contents(stream, array)
        if array.empty?
          false
        else
          stream.printf array.join("\n") + "\n"
          array.clear
          true
        end
      end


      def flush
        print_if_have_contents(self.stderr, self.class.stderr_array) || print_if_have_contents(self.stdout, self.class.stdout_array)
      end

    end
  end
end

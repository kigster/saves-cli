require 'logger'

module Saves
  module CLI
    class << self
      attr_accessor :logger

      def log(level, message = nil, &block)
        logger.send(level, message, &block) if logger
      end

    end

    self.logger = ::Logger.new(STDOUT)
  end
end


require 'saves/cli/app'

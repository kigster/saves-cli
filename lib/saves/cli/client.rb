require 'saves_client'
require 'saves_client/models/fake_save'
require 'oj'
require 'awesome_print'
require 'colored2'
require 'saves/cli/adapter'
module Saves
  module CLI
    class Client

      include SavesClient

      DEFAULT_BASE_URL    = 'http://localhost:3001'
      self.saves_base_url = DEFAULT_BASE_URL unless self.saves_base_url

      class << self
        def exec(app)
          ::Saves::CLI::Adapter.new(app, self).exec
        end
      end
    end
  end
end

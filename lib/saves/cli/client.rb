require 'saves_client'
require 'saves_client/models/fake_save'

module Saves
  module CLI
    class Client

      include SavesClient

      DEFAULT_BASE_URL    = 'http://localhost:3001'
      self.saves_base_url = DEFAULT_BASE_URL

      class << self

        def exec(app)
          self.saves_base_url = app.options[:saves_base_url] if app.options[:saves_base_url]
          self.send(app.command, app.options.merge(created_at: Time.now))
        end

        def id(options)
          print SavesClient::Models::FakeSave.new(options).composite_id
        end
      end
    end
  end
end

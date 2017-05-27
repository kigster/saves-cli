require 'saves_client'
require 'saves_client/models/fake_save'
require 'oj'

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

        def encode(options)
          output_json 'save': SavesClient::Models::FakeSave.new(options).composite_id
        end

        def decode(options)
          output_json SavesClient::Models::FakeSave.decode_composite_id(options[:save])
        end

        private

        def output_json(hash)
          str = Oj.dump(hash.stringify_keys, {})
          system("echo '#{str}' | jq")
        end
      end
    end
  end
end

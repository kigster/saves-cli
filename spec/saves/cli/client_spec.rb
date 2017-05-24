# require 'saves_client'
#
# module Saves
#   module CLI
#     class Client
#
#       include SavesClient
#
#       self.saves_base_url = 'http://localhost:3001'
#
#       class << self
#
#         def exec(parser)
#           parser.parse!
#           self.saves_base_url = parser.options[:saves_base_url] if parser.options[:saves_base_url]
#           self.send(parser.command, parser.options.merge(created_at: Time.now))
#         end
#
#       end
#
#       # For testing delegation to Saves class methods
#       def self.by_id!(id)
#         by_id(id).first
#       end
#
#       # For testing that test_saves_clients can access Save attributes
#       def attribute_to_user_id
#         user_id
#       end
#
#       def self.run!
#       end
#
#       def parser
#         self.class.parser
#       end
#     end
#   end
# end

require 'spec_helper'

RSpec.describe Saves::CLI::Client do

end

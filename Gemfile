source 'https://rubygems.org'

# Specify your gem's dependencies in saves-cli.gemspec
gemspec

unless ENV['SAVES_CLIENT_ENCRYPTION_KEY']
  gem 'saves_client', git: 'git@github.com:wanelo/saves-client.git', branch: 'ruby-2.4'
end


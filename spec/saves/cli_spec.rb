require 'spec_helper'

RSpec.describe Saves::CLI do
  it 'has a version number' do
    expect(Saves::CLI::VERSION).not_to be nil
  end

  it 'has a logger defined' do
    expect(Saves::CLI.logger).to be_nil
  end
end

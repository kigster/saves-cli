require 'spec_helper'
require 'saves/cli/app'

RSpec.describe Saves::CLI::App do

  before do
    allow(app).to receive(:print_output)
  end

  let(:argv_cli) {[]}

  subject(:app) { Saves::CLI::App.new(argv_cli) }
  let(:argv) { app.argv }

  context '#argv' do
    its(:argv) { should eq %w[--help] }
  end

  context '#options' do
    subject(:options) {app.options}
    its(:size) {should eq 0}
    its(:empty?) {should eq true}
  end

  context '#parse!' do
    let(:argv_cli) {%w(create --help) }
    before { app.parse! }
    its(:command) { should eq(:create) }
    its(:out) { should match /Usage/ }
  end

end

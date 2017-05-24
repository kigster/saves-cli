require 'spec_helper'
require 'saves/cli/app'

RSpec.describe Saves::CLI::App do

  let(:argv) {[]}

  subject(:app) { Saves::CLI::App.new(argv) }
  before { app.output.clear }
  let(:args) { app.args }

  context '#args' do
    its(:args) { should eq %w[--help] }
  end

  context '#options' do
    subject(:options) {app.options}
    its(:size) {should eq 0}
    its(:empty?) {should eq true}
  end

  context '#output' do
    subject(:output) {app.output}
    its(:size) {should eq 0}
    its(:empty?) {should eq true}
    context 'after parse!' do
      before { app.parse! }
      its(:size) { should eq 2 }
      its(:to_s) { should match /Usage/ }
    end
  end

  context '#parse!' do
    let(:argv) {%w(create --help) }
    before { app.parse! }
    its(:command) { should eq(:create) }
    its(:out) { should match /Usage/ }

  end

end

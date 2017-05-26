require 'spec_helper'

RSpec.describe Saves::CLI::Parser do
  subject(:parser_class) {described_class}

  before do
    parser_class.stdout_array.clear
  end

  context '#stdout_array' do
    subject(:stdout_array) {parser_class.stdout_array}
    its(:size) {should eq 0}
    its(:empty?) {should eq true}
    context 'after parse!' do
      before { parser_class.global.parse!(%w[--help]) }
      its(:size) { should eq 2 }
      its(:to_s) { should match /Usage/ }
    end
  end

  context '#global' do
    subject {parser_class.global}
    its(:class) {should eq Saves::CLI::Parser}
    its(:to_s) {should match /saves-cli/}

    before { subject.parse!(%w[-h])}

    context 'commands help' do
      Saves::CLI::Parser.commands.each_pair do |command, config|
        let(:output) { parser_class.stdout_array.join("\n") }
        it "should properly describe #{command}" do
          expect(output).to include(command.to_s)
          expect(output).to include(config[:description])
        end
      end
    end
  end
end

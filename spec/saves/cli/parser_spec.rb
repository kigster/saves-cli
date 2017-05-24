require 'spec_helper'

RSpec.describe Saves::CLI::Parser do
  subject(:parser_class) {described_class}

  before do
    parser_class.options.clear
    parser_class.output.clear
  end

  context '#global' do
    subject {parser_class.global}
    its(:class) {should eq Saves::CLI::Parser}
    its(:to_s) {should match /saves-cli/}

    before { subject.parse!(%w[-h])}

    context 'commands help' do
      Saves::CLI::Parser.commands.each_pair do |command, config|
        let(:output) { parser_class.output.join("\n") }
        it "should properly describe #{command}" do
          expect(output).to include(command.to_s)
          expect(output).to include(config[:description])
        end
      end
    end
  end
end

require "spec_helper"

ClimateControl.configure_rspec_metadata!

describe "Climate control RSpec metadata" do

  it "modifies the environment when tagged", climate_control: { VARIABLE_1: "bar", VARIABLE_2: "qux" } do
    expect(ENV["VARIABLE_1"]).to eq "bar"
    expect(ENV["VARIABLE_2"]).to eq "qux"
  end

  it "does not modifies the environment when not tagged" do
    expect(ENV["VARIABLE_1"]).to eq nil
    expect(ENV["VARIABLE_2"]).to eq nil
  end

  describe "works at group level", climate_control: { VARIABLE_1: "bar", VARIABLE_2: "qux" } do


    it "defines the variable for one example" do
      expect(ENV["VARIABLE_1"]).to eq "bar"
    end

    it "defines the variable for other example" do
      expect(ENV["VARIABLE_2"]).to eq "qux"
    end
  end

  describe ClimateControl::RSpec::Metadata::ClimateControlCaller do

    describe '#call' do

      subject do
        ClimateControl::RSpec::Metadata::ClimateControlCaller.new(options, example)
      end

      let(:example) do
        double(:example, run: true)
      end

      let(:message) do
        message = 'please provide a hash with your environment variable. '
        message << 'E.g climate_control: { VARIABLE_1: "bar", VARIABLE_2: "qux" }'
      end

      describe 'handle of errors' do

        context 'with boolean' do

          let(:options) do
            true
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, message)
          end
        end

        context 'with nil' do

          let(:options) do
            nil
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, message)
          end
        end

        context 'with empty hash' do

          let(:options) do
            {}
          end

          it 'raises correct error' do
            expect do
              subject.call
            end.to raise_error(ArgumentError, message)
          end
        end
      end
    end
  end
end

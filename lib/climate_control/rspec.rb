module ClimateControl
  module RSpec
    class Metadata

      def self.configure!
        ::RSpec.configure do |config|
          when_tagged_with_climate_control = { :climate_control => lambda { |v| !!v } }
          config.around(when_tagged_with_climate_control) do |example|
            options = example.metadata[:climate_control]
           ClimateControlCaller.new(options, example).call
          end
        end
      end

      class ClimateControlCaller

        def initialize(options, example)
          @options, @example  = options, example
        end

        def call
          handle_errors
          ClimateControl.modify(options) do
            example.run
          end
        end

        private

          attr_reader :options, :example

          def error_message
            message = 'please provide a hash with your environment variable. '
            message << 'E.g climate_control: { VARIABLE_1: "bar", VARIABLE_2: "qux" }'
          end

          def handle_errors
            if option_is_invalid? || options_is_empty?
              raise ArgumentError, error_message
            end
          end

          def option_is_invalid?
            !options.respond_to?(:[])
          end

          def options_is_empty?
            options.respond_to?(:[]) && options.empty?
          end
      end
    end
  end
end

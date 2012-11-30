require 'climate_control/modifier'
require 'climate_control/version'

module ClimateControl
  def self.modify(environment_overrides, &block)
    Modifier.new(environment_overrides, &block).process
  end
end

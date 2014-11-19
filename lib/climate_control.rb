require "climate_control/environment"
require "climate_control/modifier"
require "climate_control/version"

module ClimateControl
  def self.modify(environment_overrides, &block)
    Modifier.new(env, environment_overrides, &block).process
  end

  def self.env
    @env ||= ClimateControl::Environment.new
  end
end

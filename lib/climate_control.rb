require "climate_control/environment"
require "climate_control/errors"
require "climate_control/modifier"
require "climate_control/rspec"
require "climate_control/version"

module ClimateControl
  @@env = ClimateControl::Environment.new

  def self.modify(environment_overrides, &block)
    Modifier.new(env, environment_overrides, &block).process
  end

  def self.configure_rspec_metadata!
    unless @rspec_metadata_configured
      ClimateControl::RSpec::Metadata.configure!
      @rspec_metadata_configured = true
    end
  end

  def self.env
    @@env
  end
end

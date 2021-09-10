require "climate_control/errors"
require "climate_control/modifier"
require "climate_control/version"
require "monitor"

module ClimateControl
  SEMAPHORE = Monitor.new
  private_constant :SEMAPHORE

  def self.modify(environment_overrides, &block)
    Modifier.new(SEMAPHORE, env, environment_overrides, &block).call
  end

  def self.env
    ENV
  end
end

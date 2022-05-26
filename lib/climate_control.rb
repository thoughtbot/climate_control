require "climate_control/errors"
require "climate_control/version"
require "monitor"

module ClimateControl
  extend self

  SEMAPHORE = Monitor.new
  private_constant :SEMAPHORE

  def modify(environment_overrides = {}, &block)
    environment_overrides = environment_overrides.transform_keys(&:to_s)

    SEMAPHORE.synchronize do
      previous = ENV.to_hash
      middle = {}
      copy environment_overrides
      middle = ENV.to_hash
      block.call
    ensure
      after = ENV
      (previous.keys | middle.keys | after.keys).each do |key|
        if previous[key] != after[key] && middle[key] == after[key]
          ENV[key] = previous[key]
        end
      end
    end
  end

  def env
    ENV
  end

  private

  def copy(overrides)
    overrides.each do |key, value|
      ENV[key] = value
    rescue TypeError => e
      raise UnassignableValueError,
        "attempted to assign #{value} to #{key} but failed (#{e.message})"
    end
  end
end

require "climate_control/errors"
require "climate_control/version"
require "monitor"

module ClimateControl
  extend self

  SEMAPHORE = Monitor.new
  private_constant :SEMAPHORE

  def modify(environment_overrides, &block)
    environment_overrides = environment_overrides.transform_keys(&:to_s)

    SEMAPHORE.synchronize do
      pre = mid = env.to_hash
      copy environment_overrides, into: env
      mid = env.to_hash
      block.call
    ensure
      (pre.keys | mid.keys | env.keys).each do |key|
        env[key] = pre[key] if pre[key] != env[key] && mid[key] == env[key]
      end
    end
  end

  def env
    ENV
  end

  private def copy(overrides, into:)
    overrides.each do |key, value|
      into[key] = value
    rescue TypeError => e
      raise UnassignableValueError,
        "attempted to assign #{value} to #{key} but failed (#{e.message})"
    end
  end
end

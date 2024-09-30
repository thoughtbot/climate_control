require "climate_control/errors"
require "climate_control/version"
require "monitor"

module ClimateControl
  extend self
  extend Gem::Deprecate

  SEMAPHORE = Monitor.new
  private_constant :SEMAPHORE

  def modify(environment_overrides = {}, &block)
    SEMAPHORE.synchronize do
      previous = ENV.to_hash

      begin
        copy environment_overrides
      ensure
        middle = ENV.to_hash
      end

      block.call
    ensure
      after = ENV
      merge(ENV, previous: previous, middle: middle, after: after)
    end
  end

  def unsafe_modify(environment_overrides = {}, &block)
    previous = ENV.to_hash

    begin
      copy environment_overrides
    ensure
      middle = ENV.to_hash
    end

    block.call
  ensure
    after = ENV
    merge(ENV, previous: previous, middle: middle, after: after)
  end

  deprecate :unsafe_modify, :modify, 2024, 11

  def env
    ENV
  end

  deprecate :env, "ENV", 2022, 10

  private

  def copy(overrides)
    overrides.transform_keys(&:to_s).each do |key, value|
      ENV[key] = value
    rescue TypeError => e
      raise UnassignableValueError,
        "attempted to assign #{value} to #{key} but failed (#{e.message})"
    end
  end

  def merge(env, previous:, middle:, after:)
    (previous.keys | middle.keys | after.keys).each do |key|
      if previous[key] != after[key] && middle[key] == after[key]
        env[key] = previous[key]
      end
    end
  end
end

module ClimateControl
  class Modifier
    def initialize(semaphore, env, overrides = {}, &block)
      @semaphore = semaphore
      @env       = env
      @overrides = overrides.transform_keys(&:to_s)
      @block     = block
    end

    def call
      @semaphore.synchronize do
        pre = mid = @env.to_hash
        copy @overrides, to: @env
        mid = @env.to_hash
        @block.call
      ensure
        (pre.keys | mid.keys | @env.keys).each do |key|
          @env[key] = pre[key] if pre[key] != @env[key] && mid[key] == @env[key]
        end
      end
    end

    private

    def copy(overrides, to:)
      overrides.each do |key, value|
        to[key] = value
      rescue TypeError => e
        raise UnassignableValueError,
          "attempted to assign #{value} to #{key} but failed (#{e.message})"
      end
    end
  end
end

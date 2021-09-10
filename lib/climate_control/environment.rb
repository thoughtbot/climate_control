require "forwardable"
require "monitor"

module ClimateControl
  class Environment
    extend Forwardable

    def initialize
      @semaphore = Monitor.new
    end

    def_delegators :env, :[]=, :to_hash, :[], :delete, :keys

    def synchronize(&block)
      @semaphore.synchronize(&block)
    end

    private

    def env
      ENV
    end
  end
end

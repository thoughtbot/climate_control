require "thread"
require "forwardable"

module ClimateControl
  class Environment
    extend Forwardable

    def initialize
      @semaphore = Mutex.new
    end

    def_delegators :env, :[]=, :to_hash, :[], :delete
    def_delegator :@semaphore, :synchronize

    private

    def env
      ENV
    end
  end
end

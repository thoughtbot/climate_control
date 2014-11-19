require "thread"
require "active_support/core_ext/module/delegation"

module ClimateControl
  class Environment
    def initialize
      @semaphore = Mutex.new
    end

    delegate :[]=, :to_hash, :[], :delete, to: :env
    delegate :synchronize, to: :semaphore

    private

    attr_reader :semaphore

    def env
      ENV
    end
  end
end

require 'active_support/core_ext/hash/keys'

module Envmod
  class Modifier
    def initialize(environment_overrides = {}, &block)
      @environment_overrides = environment_overrides.dup.stringify_keys!
      @block = block

      process
    end

    private

    def copy_overrides_to_environment
      @environment_overrides.each do |key, value|
        ENV[key] = value
      end
    end

    def keys_to_remove
      @environment_overrides.keys
    end

    def process
      begin
        original_env = ENV.to_hash

        copy_overrides_to_environment

        env_before_block = ENV.to_hash
        @block.call
      ensure
        env_after_block = ENV.to_hash
        k2 = diff_hashes(env_before_block, env_after_block).keys
        (keys_to_remove - k2).each {|key| ENV.delete(key) }

        original_env.each do |key, value|
          ENV[key] = value
        end
      end
    end

    def diff_hashes(hash_1, hash_2)
      keys_overlap = hash_1.keys & hash_2.keys
      diff_hash = {}

      hash_2.each do |key, value|
        if hash_1[key] != value
          diff_hash[key] = value
        end
      end

      diff_hash
    end
  end
end

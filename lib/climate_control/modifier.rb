require 'active_support/core_ext/hash/keys'

module ClimateControl
  class Modifier
    def initialize(environment_overrides = {}, &block)
      @environment_overrides = environment_overrides.dup.stringify_keys!
      @block = block
    end

    def process
      begin
        prepare_environment_for_block
        run_block
      ensure
        cache_environment_after_block
        delete_keys_that_do_not_belong
        revert_changed_keys
      end
    end

    private

    def prepare_environment_for_block
      @original_env = clone_environment
      copy_overrides_to_environment
      @env_with_overrides_before_block = clone_environment
    end

    def run_block
      @block.call
    end

    def copy_overrides_to_environment
      @environment_overrides.each do |key, value|
        ENV[key] = value
      end
    end

    def keys_to_remove
      @environment_overrides.keys
    end

    def keys_changed_by_block
      @keys_changed_by_block ||= OverlappingKeysWithChangedValues.new(@env_with_overrides_before_block, @env_after_block).keys
    end

    def cache_environment_after_block
      @env_after_block = clone_environment
    end

    def delete_keys_that_do_not_belong
      (keys_to_remove - keys_changed_by_block).each {|key| ENV.delete(key) }
    end

    def revert_changed_keys
      (@original_env.keys - keys_changed_by_block).each do |key|
        ENV[key] = @original_env[key]
      end
    end

    def clone_environment
      ENV.to_hash
    end

    class OverlappingKeysWithChangedValues
      def initialize(hash_1, hash_2)
        @hash_1 = hash_1
        @hash_2 = hash_2
      end

      def keys
        overlapping_keys.select do |overlapping_key|
          @hash_1[overlapping_key] != @hash_2[overlapping_key]
        end
      end

      private

      def overlapping_keys
        @hash_2.keys & @hash_1.keys
      end
    end
  end
end

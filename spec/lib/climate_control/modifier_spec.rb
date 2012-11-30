require 'spec_helper'

describe ClimateControl::Modifier do
  it 'modifies the environment' do
    with_modified_env VARIABLE_1: 'bar', VARIABLE_2: 'qux' do
      expect(ENV['VARIABLE_1']).to eq 'bar'
      expect(ENV['VARIABLE_2']).to eq 'qux'
    end

    expect(ENV['VARIABLE_1']).to be_nil
    expect(ENV['VARIABLE_2']).to be_nil
  end

  it 'allows for environment variables to be assigned within the block' do
    with_modified_env VARIABLE_1: 'modified' do
      ENV['ASSIGNED_IN_BLOCK'] = 'assigned'
    end

    expect(ENV['ASSIGNED_IN_BLOCK']).to eq 'assigned'
  end

  it 'reassigns previously set environment variables' do
    ENV['VARIABLE_ASSIGNED_BEFORE_MODIFYING_ENV'] = 'original'
    expect(ENV['VARIABLE_ASSIGNED_BEFORE_MODIFYING_ENV']).to eq 'original'

    with_modified_env VARIABLE_ASSIGNED_BEFORE_MODIFYING_ENV: 'overridden' do
      expect(ENV['VARIABLE_ASSIGNED_BEFORE_MODIFYING_ENV']).to eq 'overridden'
    end

    expect(ENV['VARIABLE_ASSIGNED_BEFORE_MODIFYING_ENV']).to eq 'original'
  end

  it 'persists the change when overriding the variable in the block' do
    with_modified_env VARIABLE_MODIFIED_AND_THEN_ASSIGNED: 'modified' do
      ENV['VARIABLE_MODIFIED_AND_THEN_ASSIGNED'] = 'assigned value'
    end

    expect(ENV['VARIABLE_MODIFIED_AND_THEN_ASSIGNED']).to eq 'assigned value'
  end

  it 'resets environment variables even if the block raises' do
    expect {
      with_modified_env FOO: 'bar' do
        raise 'broken'
      end
    }.to raise_error

    expect(ENV['FOO']).to be_nil
  end

  it 'preserves environment variables set within the block' do
    ENV['CHANGED'] = 'old value'

    with_modified_env IRRELEVANT: 'ignored value' do
      ENV['CHANGED'] = 'new value'
    end

    expect(ENV['CHANGED']).to eq 'new value'
  end

  it 'returns the value of the block' do
    value = with_modified_env VARIABLE_1: 'bar' do
      'value inside block'
    end

    expect(value).to eq 'value inside block'
  end

  def with_modified_env(options, &block)
    ClimateControl::Modifier.new(options, &block).process
  end

  around do |example|
    old_env = ENV.to_hash

    example.run

    ENV.clear
    old_env.each do |key, value|
      ENV[key] = value
    end
  end
end

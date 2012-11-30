require 'spec_helper'

describe 'Climate control' do
  it 'allows modification of the environment' do
    block_run = false
    ClimateControl.modify FOO: 'bar' do
      expect(ENV['FOO']).to eq 'bar'
      block_run = true
    end

    expect(ENV['FOO']).to be_nil
    expect(block_run).to be_true
  end
end

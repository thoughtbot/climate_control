require 'spec_helper'

describe 'Climate control' do
  it 'allows modification of the environment' do
    ClimateControl.modify FOO: 'bar' do
      expect(ENV['FOO']).to eq 'bar'
    end

    expect(ENV['FOO']).to be_nil
  end
end

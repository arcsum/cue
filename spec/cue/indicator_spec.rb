require 'spec_helper'
require 'cue/indicator'

describe Cue::Indicator do
  let(:complete_indicator)   { Cue::Indicator.new(:complete) }
  let(:incomplete_indicator) { Cue::Indicator.new(:incomplete) }
  let(:unknown_indicator)    { Cue::Indicator.new(:unknown) }
  
  describe '#initialize' do
    it 'should set the indicator state' do
      complete_indicator.state.must_equal(:complete)
      incomplete_indicator.state.must_equal(:incomplete)
    end
  end
  
  describe '#color' do
    it 'should set the color based on state' do
      complete_indicator.color.must_equal(:green)
      incomplete_indicator.color.must_equal(:red)
      unknown_indicator.color.must_equal(:none)
    end
  end
  
  describe '#symbol' do
    it 'should set the symbol based on state' do
      complete_indicator.symbol.must_equal('✓')
      incomplete_indicator.symbol.must_equal('✗')
      unknown_indicator.symbol.must_equal('?')
    end
  end
  
  describe '#to_s' do
    it 'should return a string representation of the indicator' do
      skip 'TODO: move colorizing output to cli function'
    end
  end
end

require 'spec_helper'
require 'cue/group'

describe Cue::Group do
  let(:subject) { Cue::Group.new }
  
  describe '#items' do
    it 'should lazily initialize an array of items' do
      subject.instance_variable_get(:@items).must_be_nil
      subject.items.must_equal([])
    end
  end
  
  describe 'delegated methods' do
    let(:items) do
      mock = MiniTest::Mock.new
      
      [:each, :size].each do |method|
        mock.expect method, [].send(method)
      end
      
      [:<<, :[]].each do |method|
        arg = 0
        mock.expect method, [].send(method, arg), [arg]
      end
      
      mock
    end
    
    before { subject.instance_variable_set(:@items, items) }
    
    it 'should delegate methods to @items' do
      [:each, :size].each do |method|
        subject.send(method)
      end
      
      [:<<, :[]].each do |method|
        arg = 0
        subject.send(method, arg)
      end
      
      items.verify
    end
  end
end

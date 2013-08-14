require 'spec_helper'
require 'cue/item'
require 'cue/store/memory'

describe Cue::Store::Memory do
  let(:subject) { Cue::Store::Memory.new }
  let(:item)    { Cue::Item.new('foobar', state: :incomplete) }
  
  before do
    subject.clear
  end
  
  it 'should read and write correctly' do
    subject.write(item.hash, item)
    subject.read(item.hash).must_equal(item)
  end
  
  it 'should save items' do
    item.save(subject)    
    subject.read(item.hash).must_equal(item)
  end
  
  it 'should keep track of items' do
    items = [Cue::Item.new('foo'), Cue::Item.new('bar')]
    items.each do |item|
      item.save(subject)
    end
    
    subject.keys.must_equal(items.map(&:hash))
    
    subject.delete(items.last.hash)
    subject.keys.must_equal([items.first.hash])
  end
end

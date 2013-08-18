require 'spec_helper'
require 'cue/item'
require 'cue/store/redis'

describe Cue::Store::File do
  let(:subject) do
    Cue::Store::Redis.namespace = 'minitest'
    Cue::Store::Redis.new
  end
  
  let(:item) { Cue::Item.new('foobar', state: :incomplete) }
  
  after  { subject.clear }
  
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
    subject.delete(items.first.hash)
    subject.keys.must_equal([items.last.hash])
  end
end

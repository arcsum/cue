require 'spec_helper'
require 'cue/item'
require 'digest'

describe Cue::Item do
  let(:content) { 'foobar' }
  let(:subject) { Cue::Item.new(content) }
  
  describe '#initialize' do
    it 'should set the content' do
      subject.content.must_equal(content)
    end
    
    it 'should set the state' do
      subject.state.must_equal(:incomplete)
      Cue::Item.new(content, state: :complete).state.must_equal(:complete)
    end
  end
  
  describe '#==' do
    it 'should delegate to #to_s' do
      a = Cue::Item.new(content)
      b = Cue::Item.new(content)
      c = Cue::Item.new('bar')
      
      a.must_equal(b)
      c.must_equal(c)
      a.wont_equal(c)
      b.wont_equal(c)
    end
  end
  
  describe '#complete!' do
    it 'should set the state to complete' do
      subject.state.must_equal(:incomplete)
      subject.complete!
      subject.state.must_equal(:complete)
    end
  end
  
  describe '#hash' do
    it 'should be calculated with a sha1 digest' do
      sha = Digest::SHA1.hexdigest(subject.content)
      subject.hash.must_equal(sha)
    end
  end
  
  describe '#in_store?' do
    it 'should return false if the item is not persisted in the store' do
      store = Minitest::Mock.new
      store.expect(:read, nil, [subject.hash])
      
      refute subject.in_store?(store)
    end
    
    it 'should return true if the item has been persisted in the store' do
      store = Minitest::Mock.new
      store.expect(:read, subject, [subject.hash])
      
      assert subject.in_store?(store)
    end
  end
  
  describe '#incomplete!' do
    before { subject.instance_variable_set(:@state, :complete) }
    
    it 'should set the state to incomplete' do
      subject.state.must_equal(:complete)
      subject.incomplete!
      subject.state.must_equal(:incomplete)
    end
  end
  
  describe '#to_s' do
    it 'should return the content with a state indicator' do
      str   = subject.to_s
      words = str.split(' ')
      
      indicator = words.shift
      hash      = words.shift
      content   = words.join(' ')
      
      content.must_equal(subject.content)
    end
  end
  
  describe '#toggle!' do
    let(:complete_item)   { Cue::Item.new('a', state: :complete) }
    let(:incomplete_item) { Cue::Item.new('a', state: :incomplete) }
    
    it 'should toggle the state' do
      complete_item.toggle!.must_be(:incomplete?)
      incomplete_item.toggle!.must_be(:complete?)
    end
  end
end

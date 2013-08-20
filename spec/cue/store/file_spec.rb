require 'spec_helper'
require 'cue/item'
require 'cue/store/file'
require 'fileutils'

describe Cue::Store::File do
  let(:subject) { Cue::Store::File.new(File.join(ENV['HOME'], '.cue-test')) }
  let(:item)    { Cue::Item.new('foobar', state: :incomplete) }
  
  before { subject.clear }
  after  { subject.clear }
  
  after do
    testing_root = ::File.join(ENV['HOME'], '.cue-test').tap do |path|
      FileUtils.mkdir_p(path)
    end
    Cue::Store::File.instance_variable_set(:@root_path, testing_root)
    
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
    
    subject.keys.sort.must_equal(items.map(&:hash).sort)
    subject.delete(items.first.hash)
    subject.keys.must_equal([items.last.hash])
  end
end

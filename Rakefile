require 'rake'
require 'rake/testtask'

$:.unshift('lib')
require 'cue/item'
require 'cue/store/file'
require 'redis'

task default: :test

desc 'Open an irb session preloaded with this library.'
task :console do
  sh 'irb -I lib/ -r cue'
end

Rake::TestTask.new do |task|
  task.libs << 'spec'
  
  test_files = FileList['spec/**/*_spec.rb']
  # Skip redis tests if a redis server isn't running.
  begin
    Redis.new.ping
  rescue Redis::CannotConnectError
    msg = 'Redis server not found. Skipping spec/cue/store/redis_spec.rb ...'
    $stderr.puts(msg)
    test_files.delete('spec/cue/store/redis_spec.rb')
  end
  
  task.test_files = test_files
end

desc 'Seed with fake data.'
task :seed do
  random_state   = proc { [:complete, :incomplete].shuffle.first }
  random_length  = proc { |min, max| rand(min..max) }
  random_letter  = proc { ('a'..'z').to_a.shuffle.first }
  random_letters = proc { random_length.call(2, 8).times.map { random_letter.call }.join }
  random_words   = proc { random_length.call(4, 8).times.map { random_letters.call }.join(' ') }
  
  store = Cue::Store::File.new
  15.times do |letter|
    Cue::Item.new(random_words.call, random_state.call).save(store)
  end
end

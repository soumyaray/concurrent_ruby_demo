require 'concurrent'
require 'httparty'
require 'benchmark'

def retrieve_all(sites, repeat)
  (sites * repeat).map do |site|
    [site, HTTParty.get("http://#{site}.com")]
  end.to_h
end

def retrieve_all_future(sites, repeat)
  (sites * repeat).map do |site|
    Concurrent::Future.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

def retrieve_all_promise(sites, repeat)
  (sites * repeat).map do |site|
    Concurrent::Promise.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

def bench(sites, repeat, purpose)
  horiz = '--------------------'
  puts horiz
  puts "#{purpose} #{repeat} times"
  Benchmark.bm(7) do |bench|
    bench.report('sync:') { retrieve_all(sites, repeat) }
    bench.report('future:') { retrieve_all_future(sites, repeat) }
    bench.report('promise:') { retrieve_all_promise(sites, repeat) }
  end
end

sites = %w(cnn facebook google microsoft github)
repeat = ARGV[0].nil? ? 1 : ARGV[0].to_i

bench sites, 1, 'Rehearsal'
bench sites, repeat, 'Benchmark'

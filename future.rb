require 'concurrent'
require 'httparty'
require 'benchmark'

sites = %w(cnn facebook google microsoft github)

def retrieve_all(sites, n)
  (sites * n).map do |site|
    [site, HTTParty.get("http://#{site}.com")]
  end.to_h
end

def retrieve_all_future(sites, n)
  (sites * n).map do |site|
    Concurrent::Future.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

def retrieve_all_promise(sites, n)
  (sites * n).map do |site|
    Concurrent::Promise.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

n = ARGV[0].nil? ? 1 : ARGV[0].to_i
Benchmark.bmbm(7) do |bench|
  bench.report('sync:') { retrieve_all(sites, n) }
  bench.report('future:') { retrieve_all_future(sites, n) }
  bench.report('promise:') { retrieve_all_promise(sites, n) }
end

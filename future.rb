require 'concurrent'
require 'httparty'
require 'benchmark'

sites = %w(cnn facebook google microsoft github)

def retrieve_all(sites)
  sites.map { |site| [site, HTTParty.get("http://#{site}.com")] }.to_h
end

def retrieve_all_future(sites)
  sites.map do |site|
    Concurrent::Future.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

def retrieve_all_promise(sites)
  sites.map do |site|
    Concurrent::Promise.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

n = ARGV[0].nil? ? 1 : ARGV[0].to_i
Benchmark.bmbm(7) do |bench|
  bench.report('sync:') { n.times { retrieve_all(sites) } }
  bench.report('future:') { n.times { retrieve_all_future(sites) } }
  bench.report('promise:') { n.times { retrieve_all_promise(sites) } }
end

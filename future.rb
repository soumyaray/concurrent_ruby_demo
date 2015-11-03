require 'concurrent'
require 'httparty'
require 'benchmark'

sites = %w(cnn facebook google microsoft github)

def retrieve_all(sites)
  sites.map { |site| [site, HTTParty.get("http://#{site}.com")] }.to_h
end

def retrieve_all_async(sites)
  sites.map do |site|
    Concurrent::Future.new { [site, HTTParty.get("http://#{site}.com")] }
  end.map(&:execute).map(&:value).to_h
end

Benchmark.bmbm(7) do |bench|
  bench.report('sync:') { retrieve_all(sites) }
  bench.report('async:') { retrieve_all_async(sites) }
end

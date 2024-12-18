# frozen_string_literal: true

require 'http'
require 'concurrent'
require 'benchmark'

def retrieve(sites)
  sites.map do |site|
    result = HTTP.follow.get("https://#{site}.com")
    { site: site, code: result.status, body: result.body.to_s }
  rescue StandardError
    { error: "#{site} could not be loaded" }
  end
end

def retrieve_concurrent(sites)
  sites.map do |site|
    Concurrent::Promise
      .new { HTTP.follow.get("http://#{site}.com") }
      .then { |res| { site: site, code: res.status, body: res.body.to_s } }
      .rescue { { error: "#{site} could not be loaded" } }
      .execute
  end.map(&:value!)
end

# Demonstration

sites = %w[cnn facebook google github]
retrieve(sites)
retrieve_concurrent(sites)

# Performance Comparison

Benchmark.measure { retrieve(sites) }
Benchmark.measure { retrieve_concurrent(sites) }

Benchmark.bm(12) do |bench|
  bench.report('synchronous:') { retrieve(sites) }
  bench.report('concurrent:') { retrieve_concurrent(sites) }
end;

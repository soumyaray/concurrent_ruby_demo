require 'http'
require 'concurrent'
require 'benchmark'

def retrieve_all(sites)
  sites.map do |site|
    result = HTTP.follow.get("https://#{site}.com")
    { site: site, code: result.status, body: result.body.to_s }
  end
end

def retrieve_all_concurrent(sites)
  sites.map do |site|
    Concurrent::Promise
      .new { HTTP.follow.get("http://#{site}.com") }
      .then { |res| { site: site, code: res.status, body: res.body.to_s } }
      .rescue { "#{site} could not be loaded" }
  end.map(&:execute).map(&:value)
end

def bench(sites)
  Benchmark.bm(10) do |bench|
    bench.report('sync:') { retrieve_all(sites) }
    bench.report('concurrent:') { retrieve_all_concurrent(sites) }
  end
end

sites = %w(cnn facebook google microsoft github)
# frozen_string_literal: true

require 'concurrent'

promise = Concurrent::Promise.execute do
  sleep(20)
  21 * 2
end

promise.state
promise.pending?
promise.value

promise = Concurrent::Promise.execute { raise 'hell' }.rescue { 666 }
promise.state
promise.pending?
promise.value

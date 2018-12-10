# frozen_string_literal: true

require 'concurrent'

promise = Concurrent::Promise.execute do
  sleep(20)
  21 * 2
end;

promise.state     # => pending
promise.pending?  # => true
promise.value     # => 42 (after waiting!)

promise = Concurrent::Promise.execute { raise 'hell' }.rescue { 666 };
promise.state     # => fulfilled
promise.pending?  # => false
promise.value     # => 666

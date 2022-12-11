# frozen_string_literal: true

def wait
  (1..5).to_a.map do
    sleep(2); true
  end
end

def wait_concurrent
  (1..5).to_a.map do
    Concurrent::Promise
      .new { sleep(2); true }
      .execute;
  end.map(&:value!)
end

class BankAccount
  attr_accessor :balance, :half

  def initialize(starting_balance=0)
    @balance = starting_balance
    @half = @balance / 2
  end

  def debit(amount)
    @balance -= amount
  end

  def credit(amount)
    @balance += amount
  end
end

thread_count = 100
iterate = 1_000_000
total = thread_count * iterate

account = BankAccount.new(0)

puts "Starting balance is #{account.balance}."

## Synchronous crediting
# puts "Crediting account using a single thread, #{total} times."
# total.times do
#   account.half += 1 if account.balance.even?
#   account.credit(1)
# end

## Multithreaded crediting
puts "Crediting account using #{thread_count} threads, #{iterate} times each."
require 'thread'
threads = (0...thread_count).map do
  Thread.new do
    iterate.times do
      account.half += 1 if account.balance.even?
      account.credit(1)
    end
  end
end
threads.each(&:join)

puts "Account balance is now #{account.balance}."
puts "Half balance is now #{account.half}."

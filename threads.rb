class BankAccount
  attr_accessor :balance

  def initialize(starting_balance=0)
    @balance = starting_balance
  end

  def debit(amount)
    new_amount = @balance - amount
    update_server(new_amount)
    @balance = new_amount
  end

  def credit(amount)
    new_amount = @balance + amount
    update_server(new_amount)
    @balance = new_amount
  end

  def update_server(new_amount)
    sleep 0.000001 # simulate a small networking delay
  end
end

thread_count = 100
iterate = 200
total = thread_count * iterate

## Synchronous crediting
account1 = BankAccount.new(total)
account2 = BankAccount.new(0)
puts "Account 1 starting balance is #{account1.balance}."
puts "Account 2 starting balance is #{account2.balance}."

puts "Transferring funds using a single thread, #{total} times."
total.times do |i|
  account1.debit(1)
  account2.credit(1)
  print '.' if i % 100 == 0
end

puts
puts "Account 1 ending balance is #{account1.balance}."
puts "Account 2 ending balance is #{account2.balance}."

## Multithreaded crediting
account1 = BankAccount.new(total)
account2 = BankAccount.new(0)
puts "Account 1 starting balance is #{account1.balance}."
puts "Account 2 starting balance is #{account2.balance}."

puts "Transferring funds using #{thread_count} threads, #{iterate} times each."
require 'thread'
threads = thread_count.times.map.with_index do |_, i|
  Thread.new do
    iterate.times do
      account1.debit(1)
      account2.credit(1)
      print '.' if i % 100 == 0
    end
  end
end
threads.each(&:join)

puts
puts "Account 1 ending balance is #{account1.balance}."
puts "Account 2 ending balance is #{account2.balance}."

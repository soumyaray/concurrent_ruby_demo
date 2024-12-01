class BankAccount
  attr_accessor :balance, :half

  def initialize(starting_balance=0)
    @balance = starting_balance
    @half = @balance / 2
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
account = BankAccount.new(0)
puts "Starting balance is #{account.balance}."

puts "Crediting account using a single thread, #{total} times."
total.times do
  account.half += 1 if account.balance.even?
  account.credit(1)
  print '.' if account.balance % 100 == 0
end

puts
puts "Account balance is now #{account.balance}."
puts "Half balance is now #{account.half}."

## Multithreaded crediting
account = BankAccount.new(0)
puts "Starting balance is #{account.balance}."

puts "Crediting account using #{thread_count} threads, #{iterate} times each."
require 'thread'
threads = thread_count.times.map do
  Thread.new do
    iterate.times do
      account.half += 1 if account.balance.even?
      account.credit(1)
      print '.' if account.balance % 100 == 0
    end
  end
end
threads.each(&:join)

puts
puts "Account balance is now #{account.balance}."
puts "Half balance is now #{account.half}."

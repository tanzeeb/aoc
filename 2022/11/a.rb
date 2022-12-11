#!/usr/bin/env ruby
# frozen_string_literal: true

monkeys = []

current = 0
ARGF.readlines(chomp: true).each do |line|
  case line
  when /^Monkey (\d+):$/
    current = $1.to_i
    monkeys << {count: 0}
  when /^\W+Starting items: (.+)$/
    items = $1.split(/, /).map(&:to_i)
    monkeys[current][:items] = items
  when /^\W+Operation: (.+)$/
    op = -> (expr) { eval "-> (old) { #{expr}; new / 3 }" }.call($1)
    monkeys[current][:op] = op
  when /^\W+Test: divisible by (\d+)$/
    div = $1.to_i
    monkeys[current][:test] = {div: div}
  when /^\W+If true: throw to monkey (\d+)$/
    t = $1.to_i
    monkeys[current][:test][:true] = t
  when /^\W+If false: throw to monkey (\d+)$/
    f = $1.to_i
    monkeys[current][:test][:false] = f
  end
end

def round! monkeys
  monkeys.each do |monkey|
    while old = monkey[:items].shift
      monkey[:count] += 1

      new = monkey[:op].call old

      if new % monkey[:test][:div] == 0
        monkeys[monkey[:test][:true]][:items] << new
      else
        monkeys[monkey[:test][:false]][:items] << new
      end
    end
  end
end

20.times { round! monkeys }

monkey_business = monkeys.map {|m| m[:count] }.sort.last(2).reduce(:*)

puts monkey_business

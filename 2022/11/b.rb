#!/usr/bin/env ruby
# frozen_string_literal: true

monkeys = []
items = []

current = 0
ARGF.readlines(chomp: true).each do |line|
  case line
  when /^Monkey (\d+):$/
    current = $1.to_i
    monkeys << {id: current, count: 0}
  when /^\W+Starting items: (.+)$/
    $1.split(/, /).map(&:to_i).each do |item|
      items << { start: item, monkey: current, worries: {} }
    end
  when /^\W+Operation: (.+)$/
    monkeys[current][:op] = $1
  when /^\W+Test: divisible by (\d+)$/
    div = $1.to_i
    monkeys[current][:div] = div
  when /^\W+If true: throw to monkey (\d+)$/
    t = $1.to_i
    monkeys[current][:true] = t
  when /^\W+If false: throw to monkey (\d+)$/
    f = $1.to_i
    monkeys[current][:false] = f
  end
end

monkeys.each do |monkey|
  worry_expr = "#{monkey[:op]}"
  monkey[:worry] = -> (old) { eval worry_expr }

  throw_expr = "new % #{monkey[:div]} == 0 ? #{monkey[:true]} : #{monkey[:false]}"
  monkey[:throw] = -> (new) { eval throw_expr }

  items.each do |item|
    item[:worries][monkey[:id]] = item[:start] % monkey[:div]
  end
end

def round! monkeys, items
  monkeys.each do |monkey|
    items.select {|m| m[:monkey] == monkey[:id]}.each do |item|
      monkey[:count] += 1

      monkeys.each do |m|
        new = monkey[:worry].call(item[:worries][m[:id]])
        item[:worries][m[:id]] = new % m[:div]
      end

      item[:monkey] = monkey[:throw].call(item[:worries][monkey[:id]])
    end
  end
end

10000.times { round! monkeys, items }

monkey_business = monkeys.map {|m| m[:count] }.sort.last(2).reduce(:*)

puts monkey_business

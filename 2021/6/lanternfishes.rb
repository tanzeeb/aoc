#!/usr/bin/env ruby
# frozen_string_literal: true

DAY = 256

populations = Hash.new do |pop, days|
  pop[days] = if days < 0
    1
  else
    counter = 1

    spawn = days / 7 + 1

    spawn.times do |count|
      day = days - count*7 - 9

      counter += day < 0 ? 1 : pop[day]
    end

    counter
  end
end

fishes = ARGF.readline.chomp.split(",").map(&:to_i)

puts fishes.sum { |timer| populations[DAY-timer-1] }

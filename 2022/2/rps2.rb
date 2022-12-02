#!/usr/bin/env ruby
# frozen_string_literal: true

total = 0

ARGF.readlines(chomp: true).each do |line|
  opps, me = line.split(/ /)

  outcome = case me
            when "X" then 0
            when "Y" then 3
            when "Z" then 6
            end

  shape = case line
          when "A X" then 3
          when "A Y" then 1
          when "A Z" then 2
          when "B X" then 1
          when "B Y" then 2
          when "B Z" then 3
          when "C X" then 2
          when "C Y" then 3
          when "C Z" then 1
          end

  score = shape + outcome

  total += score
end

puts total

#!/usr/bin/env ruby
# frozen_string_literal: true

total = 0

ARGF.readlines(chomp: true).each do |line|
  opps, me = line.split(/ /)

  shape = case me
          when "X" then 1
          when "Y" then 2
          when "Z" then 3
          end

  outcome = case line
            when "A X" then 3
            when "A Y" then 6
            when "A Z" then 0
            when "B X" then 0
            when "B Y" then 3
            when "B Z" then 6
            when "C X" then 6
            when "C Y" then 0
            when "C Z" then 3
            end

  score = shape + outcome

  total += score
end

puts total

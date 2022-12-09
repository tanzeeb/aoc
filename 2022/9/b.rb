#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

knots = Array.new(10) { [0,0] }

history = Set.new

history << knots.last.to_s

pp knots

ARGF.readlines(chomp: true).each do |line|
  puts line

  case line
  when /^U (\d+)$/
    $1.to_i.times do 
      knots[0][1] += 1
      9.times do |i|
        if knots[i][1] - knots[i+1][1] > 1
          knots[i+1][1] = knots[i][1] - 1
          knots[i+1][0] = knots[i][0]
        end
      pp knots
      end
      history << knots.last.to_s
    end
  when /^D (\d+)$/
    $1.to_i.times do 
      knots[0][1] -= 1
      9.times do |i|
        if knots[i][1] - knots[i+1][1] < -1
          knots[i+1][1] = knots[i][1] + 1
          knots[i+1][0] = knots[i][0]
        end
      end
      history << knots.last.to_s
    end
  when /^R (\d+)$/
    $1.to_i.times do 
      knots[0][0] += 1
      9.times do |i|
        if knots[i][0] - knots[i+1][0] > 1
          knots[i+1][0] = knots[i][0] - 1
          knots[i+1][1] = knots[i][1]
        end
      end
      history << knots.last.to_s
    end
  when /^L (\d+)$/
    $1.to_i.times do 
      knots[0][0] -= 1
      9.times do |i|
        if knots[i][0] - knots[i+1][0] < -1
          knots[i+1][0] = knots[i][0] + 1
          knots[i+1][1] = knots[i][1]
        end
      end
      history << knots.last.to_s
    end
  end
  pp knots
end

pp history

puts history.size

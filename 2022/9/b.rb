#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

knots = Array.new(10) { [0,0] }

history = Set.new

history << knots.last.to_s

def delta a, b
  return 0 if a == b

  a > b ? -1 : 1
end

def update! knots
  9.times do |i|
    if knots[i][1] - knots[i+1][1] > 1
      knots[i+1][1] = knots[i][1] - 1
      knots[i+1][0] += delta knots[i+1][0], knots[i][0]
    end
    if knots[i][1] - knots[i+1][1] < -1
      knots[i+1][1] = knots[i][1] + 1
      knots[i+1][0] += delta knots[i+1][0], knots[i][0]
    end
    if knots[i][0] - knots[i+1][0] > 1
      knots[i+1][0] = knots[i][0] - 1
      knots[i+1][1] += delta knots[i+1][1], knots[i][1]
    end
    if knots[i][0] - knots[i+1][0] < -1
      knots[i+1][0] = knots[i][0] + 1
      knots[i+1][1] += delta knots[i+1][1], knots[i][1]
    end
  end
end

def draw knots
  #min_x,max_x = knots.map { |k| k[0] }.minmax
  #min_y,max_y = knots.map { |k| k[1] }.minmax

  chart = Array.new(30) { Array.new(30,".") }

  knots.each.with_index do |k,i|
    chart[15-k[1]][15+k[0]] = i.to_s
  end

  chart.each do |line|
    puts line.join("")
  end
  puts ""
end

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^U (\d+)$/
    $1.to_i.times do 
      knots[0][1] += 1
      update! knots
      history << knots.last.to_s
    end
  when /^D (\d+)$/
    $1.to_i.times do 
      knots[0][1] -= 1
      update! knots
      history << knots.last.to_s
    end
  when /^R (\d+)$/
    $1.to_i.times do 
      knots[0][0] += 1
      update! knots
      history << knots.last.to_s
    end
  when /^L (\d+)$/
    $1.to_i.times do 
      knots[0][0] -= 1
      update! knots
      history << knots.last.to_s
    end
  end
end

puts history.size

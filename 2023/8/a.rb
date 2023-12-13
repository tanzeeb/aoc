#!/usr/bin/env ruby
# frozen_string_literal: true

START = "AAA"
FINISH = "ZZZ"

ins = nil
nodes = {}

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^\w+$/
    ins = line.split(//)
  when /^(\w+) = \((\w+), (\w+)\)$/
    nodes[$1] = { "L" => $2, "R" => $3 }
  end
end

current = START
count = 0

ins.cycle do |i|
  count += 1
  current = nodes[current][i]

  break if current == FINISH
end

pp count

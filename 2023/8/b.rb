#!/usr/bin/env ruby
# frozen_string_literal: true

START = /\w\wA/
FINISH = /\w\wZ/

instructions = nil
nodes = {}

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^\w+$/
    instructions = line.split(//)
  when /^(\w+) = \((\w+), (\w+)\)$/
    nodes[$1] = { "L" => $2, "R" => $3 }
  end
end

starts = nodes.keys.grep(START)

paths = Hash[ starts.map { |s| [s,s] } ]
done = Hash[ starts.map { |s| [s,{}] } ]
cycles = {}

count = 0
index = 0

until paths.empty?
  instruction = instructions[index]
  count += 1

  paths.keys.each do |key|
    step = nodes[paths[key]][instruction]

    paths[key] = step
    
    if step =~ FINISH
      if done[key].has_key? [step, index]
        cycles[key] = done[key][[step, index]]
        paths.delete key
      else
        done[key][[step, index]] = count
      end
    end
  end

  index = index.next % instructions.size
end

pp cycles.values.reduce(&:lcm)

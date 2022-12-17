#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

tunnels = {}

ARGF.readlines(chomp: true).each do |line|
  _, valve, _, _, _, rate, _, _, _, _, _, *to = line.split(/[ ,=;]/)

  tunnels[valve] = { rate: rate.to_i, to: to.reject(&:empty?) }
end

def max tunnels, valve, rate, total, minutes
  if minutes == 0
    puts total
    return total 
  end

  options = []

  tunnels[valve][:to].each do |v|
    r = tunnels[valve][:rate]

    options << max(tunnels, v, rate, total + rate, minutes - 1)

    options << max(tunnels, v, rate + r, total + rate + rate + r, minutes - 2) if minutes > 1
  end

  options.max
end

# max tunnels, "AA", 0, 0, 30

def pressure tunnels, start, minutes
  queue = Set[]
  totals = Hash.new(-1)

  queue << [start,Set.new,1]
  totals[[start,Set.new,1]] = 0

  all = Set[*tunnels.select {|k,v| v[:rate] > 0}.map {|k,_| k}]
  pp all

  current = nil

  until queue.empty?
    current = totals.select{|k,_| queue.include? k}.sort_by{|_,v| v}.last.first
    puts "#{current} #{totals[current]}"

    queue.delete current

    break if current[1] == all && current.last == minutes
    next if current.last == minutes

    moves = [[[current.first,current[1],current.last+1],0]]
    tunnel = tunnels[current.first]

    tunnel[:to].each do |valve|
      m = current.last + 1
      moves << [[valve, current[1], m], 0]

      if m < minutes && tunnels[valve][:rate] > 0 && !current[1].include?(valve)
        moves << [[valve,current[1].dup.add(valve),m+1], (minutes-m)*tunnels[valve][:rate]]
      end
    end

    moves.each do |(valve,delta)|
      puts "- #{valve} - #{delta}"
      new = totals[current] + delta

      queue << valve unless new < totals[valve]
      #queue << valve if new > totals[valve]
      totals[valve] = new if new > totals[valve]
    end
  end

  totals[current]
end

puts "---"
puts pressure tunnels, "AA", 30

#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

head = [0,0]
tail = [0,0]

history = Set.new

history << tail.to_s

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^U (\d+)$/
    $1.to_i.times do 
      head[1] += 1
      if head[1] - tail[1] > 1
        tail[1] = head[1] - 1
        tail[0] = head[0]
      end
      history << tail.to_s
    end
  when /^D (\d+)$/
    $1.to_i.times do 
      head[1] -= 1
      if head[1] - tail[1] < -1
        tail[1] = head[1] + 1
        tail[0] = head[0]
      end
      history << tail.to_s
    end
  when /^R (\d+)$/
    $1.to_i.times do 
      head[0] += 1
      if head[0] - tail[0] > 1
        tail[0] = head[0] - 1
        tail[1] = head[1]
      end
      history << tail.to_s
    end
  when /^L (\d+)$/
    $1.to_i.times do 
      head[0] -= 1
      if head[0] - tail[0] < -1
        tail[0] = head[0] + 1
        tail[1] = head[1]
      end
      history << tail.to_s
    end
  end
end

puts history.size

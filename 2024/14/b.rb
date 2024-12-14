#!/usr/bin/env ruby
# frozen_string_literal: true

@rows = 103
@cols = 101

if ARGV.first != 'input.txt'
  @rows = 7
  @cols = 11
end

@robots = ARGF.readlines(chomp: true).map do |line|
  line.split(' ').map do |part|
    part.split('=').last.split(',').map(&:to_i)
  end
end

@positions = Hash.new(0)

def draw
  @rows.times do |y|
    @cols.times do |x|
      c = @positions[[x, y]]
      print c.zero? ? '.' : c.to_s
    end
    puts
  end
end

i = 0
loop do
  @positions.clear
  @robots.each do |(s, v)|
    p = [
      (s.first + (i * v.first)) % @cols,
      (s.last + (i * v.last)) % @rows
    ]

    @positions[p] += 1
  end

  if @positions.all? { |_p, v| v == 1 }
    puts "#{i} seconds"
    draw
    break
  end

  i += 1
end

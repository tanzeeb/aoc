#!/usr/bin/env ruby
# frozen_string_literal: true

@x = 1
@cycle = 0

@strength = 0

def tick!
  @cycle += 1

  if ((@cycle - 20) % 40) == 0
    @strength += @cycle * @x
  end
end

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^addx (.+)$/
    tick!
    tick!
    @x += $1.to_i
  when /^noop$/
    tick!
  end
end

puts @strength

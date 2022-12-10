#!/usr/bin/env ruby
# frozen_string_literal: true

@x = 1
@cycle = 0

@strength = 0

@screen = Array.new(6) { Array.new(40) }

def tick!
  @cycle += 1

  draw!
end

def draw!
  row = (@cycle-1) / 40
  col = (@cycle-1) % 40

  @screen[row][col] = (@x-col).abs > 1 ? "." : "#"
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

puts @screen.map { |row| row.join("") }.join("\n"), "\n"

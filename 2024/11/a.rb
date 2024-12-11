#!/usr/bin/env ruby
# frozen_string_literal: true

@stones = ARGF.readline(chomp: true).split(/ /).map(&:to_i)

@count = Hash.new do |h, k|
  stone = k.first
  count = k.last

  mark = stone.to_s
  left = mark[0...mark.size / 2].to_i
  right = mark[mark.size / 2..].to_i

  h[k] = if count.zero?
           1
         elsif stone.zero?
           h[[1, count - 1]]
         elsif mark.size.even?
           h[[left, count - 1]] + h[[right, count - 1]]
         else
           h[[stone * 2024, count - 1]]
         end
end

puts(@stones.sum { |stone| @count[[stone, 25]] })

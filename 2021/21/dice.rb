#!/usr/bin/env ruby
# frozen_string_literal: true

pawns = ARGF.readlines(chomp: true).map { |line| line.split(': ').last.to_i }
dice = 100
rolls = 0

scores = [0,0]

loop do
  pawns.size.times do |i|
    spaces = 3.times.map { dice = dice % 100 + 1 }.sum
    rolls += 3

    pawns[i] = (pawns[i]+spaces-1) % 10 + 1

    scores[i] += pawns[i]

    if scores[i] >= 1000
      puts scores.min * rolls

      exit
    end
  end
end


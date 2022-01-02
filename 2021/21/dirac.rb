#!/usr/bin/env ruby
# frozen_string_literal: true

win_condition = 21

pawns = ARGF.readlines(chomp: true).map { |line| line.split(': ').last.to_i }

rolls = Hash.new(0)

[ [1]*3, [2]*3, [3]*3 ].flatten.permutation(3).uniq.each do |roll|
  rolls[roll.sum] += 1
end

games = Hash.new do |h,k|
  player, positions, scores = k
  opponent = (player+1)%2

  wins = [0,0]

  rolls.each do |roll, count|
    position = (positions[player]+roll-1)%10+1
    score = scores[player] + position
    
    if score >= win_condition
      wins[player] += count
    else
      next_positions = positions.dup
      next_positions[player] = position

      next_scores = scores.dup
      next_scores[player] = score

      subtotal = h[[opponent, next_positions, next_scores]]

      wins[0] += subtotal[0]*count
      wins[1] += subtotal[1]*count
    end
  end

  h[k] = wins
end

puts games[[0,pawns,[0,0]]].max

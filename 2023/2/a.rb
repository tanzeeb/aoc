#!/usr/bin/env ruby
# frozen_string_literal: true

FILTER = { "red" => 12, "green" => 13, "blue" => 14 }

games = ARGF.readlines(chomp: true).map do |game|
  {}.tap do |max|
    game.scan(/(\d+) ([a-z]+)/).each do |(count,colour)| 
      max[colour] = count.to_i if max[colour].to_i < count.to_i
    end
  end
end

puts games.map.with_index { |g,i| FILTER.all? { |(k,v)| g[k] <= v } ? i+1 : 0 }.sum


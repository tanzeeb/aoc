#!/usr/bin/env ruby
# frozen_string_literal: true

numbers = ARGF.readline.chomp.split(',')

cards = ARGF.readlines.each_slice(6).map { |lines| lines[1..].map &:split }

numbers.each do |number|
  cards.map! { |card| card.map! { |row| row.map! { |entry| entry == number ? "-" : entry } } }

  winners, cards = cards.partition do |card|
    card.any? { |row| row.all? { |entry| entry == "-" } } ||
      (0..card.first.length).any? { |index| card.all? { |row| row[index] == "-" } }
  end

  if cards.empty?
    puts winners.first.flatten.map(&:to_i).sum * number.to_i

    break
  end
end


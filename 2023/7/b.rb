#!/usr/bin/env ruby
# frozen_string_literal: true

S = [
  "A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"
]

hands = ARGF.readlines(chomp: true).map do |line|
  hand, bid = line.split " "
  cards = hand.split(//)

  tally = cards.tally

  jtally = tally.dup

  if tally.keys.size > 1 && tally.has_key?("J")
    j = jtally["J"]
    jtally.delete "J"

    m = jtally.max_by {|_,v| v}.first

    jtally[m] += j
  end
  

  { hand: hand, bid: bid.to_i, cards: cards, tally: tally, jtally: jtally }
end

hands.sort! do |a,b|
  next 1 if a[:jtally].values.max > b[:jtally].values.max
  next -1 if a[:jtally].values.max < b[:jtally].values.max

  next 1 if a[:jtally].keys.size < b[:jtally].keys.size
  next -1 if a[:jtally].keys.size > b[:jtally].keys.size

  ret = 0
  a[:cards].zip(b[:cards]) { |ca,cb|
    d = S.index(cb) - S.index(ca)

    unless d.zero?
      ret = d/d.abs
      break
    end
  }

  ret
end

hands.each.with_index { |h,i| h[:rank] = i+1 }

pp hands.sum {|h| h[:bid] * h[:rank]}

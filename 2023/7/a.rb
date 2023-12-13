#!/usr/bin/env ruby
# frozen_string_literal: true

S = [
  "A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"
]

hands = ARGF.readlines(chomp: true).map do |line|
  hand, bid = line.split " "
  cards = hand.split(//)

  { hand: hand, bid: bid.to_i, cards: cards, tally: cards.tally }
end

hands.sort! do |a,b|
  next 1 if a[:tally].values.max > b[:tally].values.max
  next -1 if a[:tally].values.max < b[:tally].values.max

  next 1 if a[:tally].keys.size < b[:tally].keys.size
  next -1 if a[:tally].keys.size > b[:tally].keys.size

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

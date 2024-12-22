#!/usr/bin/env ruby
# frozen_string_literal: true

@initials = ARGF.readlines(chomp: true).map(&:to_i)

@next = Hash.new do |h, k|
  value = k

  value = ((value * 64) ^ value) % 16_777_216

  value = ((value / 32) ^ value) % 16_777_216

  value = ((value * 2048) ^ value) % 16_777_216

  h[k] = value
end

@changes = @initials.map do |initial|
  prices = [initial % 10]
  secret = initial

  2000.times do
    secret = @next[secret]

    prices << secret % 10
  end

  deltas = prices.each_cons(2).map { |(m, n)| n - m }

  changes = Hash.new(0)

  deltas.each_cons(4).with_index do |seq, i|
    price = prices[i + 4]

    changes[seq] = price unless changes.key?(seq)
  end

  changes
end

@totals = Hash.new(0)

@changes.each do |changes|
  changes.each do |seq, price|
    @totals[seq] += price
  end
end

_, bananas = @totals.max_by { |_, v| v }

puts bananas

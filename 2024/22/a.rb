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

sum = @initials.sum do |initial|
  secret = initial

  2000.times do |_i|
    secret = @next[secret]
  end

  secret
end

puts sum

#!/usr/bin/env ruby
# frozen_string_literal: true

current = 50
count = 0

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^L(\d+)$/
    current = (current - Regexp.last_match(1).to_i) % 100
  when /^R(\d+)$/
    current = (current + Regexp.last_match(1).to_i) % 100
  end

  count += 1 if current.zero?
end

puts count

#!/usr/bin/env ruby
# frozen_string_literal: true

def filter(lines, pos, cond)
  return lines.first unless lines.size > 1 && pos < lines.first.size

  ones, zeroes = lines.partition { |line| line[pos] == '1' }

  keep = zeroes.size.send(cond, ones.size) ? zeroes : ones

  filter(keep, pos + 1, cond)
end

lines = ARGF.readlines

oxygen = filter lines, 0, :>
co2 = filter lines, 0, :<=

puts co2.to_i(2) * oxygen.to_i(2)

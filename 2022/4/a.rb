#!/usr/bin/env ruby
# frozen_string_literal: true

pairs = 0

ARGF.readlines(chomp: true).each do |line|
  a, b = line.split(/,/)
  as, ae = a.split(/-/).map(&:to_i)
  bs, be = b.split(/-/).map(&:to_i)

  pairs += 1 if ( (as >= bs && ae <= be) || (bs >= as && be <= ae) )
end

puts pairs

#!/usr/bin/env ruby
# frozen_string_literal: true

@equations = ARGF.readlines(chomp: true).map do |e|
  r, expr = e.split(/:\W+/)

  [r.to_i, expr.split(/\W+/).map(&:to_i)]
end

def match?(left, right, rest)
  return left == right if rest.empty?

  match?(left, right * rest.first, rest[1..]) || match?(left, right + rest.first, rest[1..])
end

puts(@equations.filter { |(r, op)| match? r, op.first, op[1..] }.sum { |(r, _)| r })

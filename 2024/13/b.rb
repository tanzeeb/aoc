#!/usr/bin/env ruby
# frozen_string_literal: true

@machines = ARGF.readlines(chomp: true).slice_before(/^$/).map do |lines|
  lines.reject!(&:empty?)

  a, b, p = lines.map { |l| l.scan(/(\d+)[^\d]+(\d+)$/).first.map(&:to_i) }

  [a, b, p.map { |v| v + 10_000_000_000_000 }]
end

@tokens = @machines.map do |a, b, p|
  an = (p.first * b.last) - (b.first * p.last)
  bn = (a.first * p.last) - (p.first * a.last)

  d = (a.first * b.last) - (b.first * a.last)

  (3 * an / d) + (bn / d) if !d.zero? && (an % d).zero? && (bn % d).zero?
end

pp @tokens.reject(&:nil?).sum

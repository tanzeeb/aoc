#!/usr/bin/env ruby
# frozen_string_literal: true

@machines = ARGF.readlines(chomp: true).slice_before(/^$/).map do |lines|
  lines.reject!(&:empty?)

  lines.map { |l| l.scan(/(\d+)[^\d]+(\d+)$/).first.map(&:to_i) }
end

@tokens = @machines.map do |a, b, prize|
  cost = nil

  ai = 0
  while ai < 100

    bi = 0
    while bi < 100
      x = ai * a.first + bi * b.first
      y = ai * a.last + bi * b.last

      if x == prize.first && y == prize.last
        cost = 3 * ai + 1 * bi

        break
      end

      bi += 1
    end

    ai += 1
  end

  cost
end

pp @tokens.reject(&:nil?).sum

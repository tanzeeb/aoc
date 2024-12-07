#!/usr/bin/env ruby
# frozen_string_literal: true

rules_text, updates_text = ARGF.read.split(/^$\n/)

@rules = rules_text.split(/\n/).map { |r| r.split(/\|/).map(&:to_i) }

@updates = updates_text.split(/\n/).map { |u| u.split(/,/).map(&:to_i) }

@indexes = @updates.map do |update|
  h = {}

  update.each_with_index do |page, i|
    h[page] = i
  end

  h
end

sum = 0

@updates.zip(@indexes) do |update, indexes|
  sum += update[update.size / 2] if @rules.all? do |(before, after)|
    if indexes[before] && indexes[after]
      indexes[before] < indexes[after]
    else
      true
    end
  end
end

puts sum

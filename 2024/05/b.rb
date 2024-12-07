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

def valid?(before, after, indexes)
  return true unless indexes[before] && indexes[after]

  indexes[before] < indexes[after]
end

@bad = @updates.reject.with_index do |_update, i|
  @rules.all? { |(before, after)| valid? before, after, @indexes[i] }
end

sum = 0

@bad.each do |update|
  update.sort! do |a, b|
    if @rules.any? { |(before, after)| before == a && after == b }
      -1
    elsif @rules.any? { |(before, after)| before == b && after == a }
      1
    else
      0
    end
  end

  sum += update[update.size / 2]
end

puts sum

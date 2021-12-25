#!/usr/bin/env ruby
# frozen_string_literal: true

crabs = ARGF.readline.split(",").map(&:to_i)

puts (crabs.min..crabs.max).map { |position|
  crabs.sum { |crab| (position-crab).abs }
}.min

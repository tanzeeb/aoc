#!/usr/bin/env ruby
# frozen_string_literal: true

crabs = ARGF.readline.split(",").map(&:to_i)

puts (crabs.min..crabs.max).map { |position|
  crabs.sum do |crab| 
    distance = (position-crab).abs 

    ( distance * (distance + 1) ) / 2
  end
}.min

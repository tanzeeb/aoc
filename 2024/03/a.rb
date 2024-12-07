#!/usr/bin/env ruby
# frozen_string_literal: true

instructions = ARGF.read

expression = /mul\((\d{1,3}),(\d{1,3})\)/

puts instructions.scan(expression).map { |a, b| a.to_i * b.to_i }.sum

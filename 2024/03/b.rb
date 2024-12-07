#!/usr/bin/env ruby
# frozen_string_literal: true

filter = /do\(\)(.*?)(?:don't\(\))/m

instructions = "do()#{ARGF.read}".scan(filter)

expression = /mul\((\d{1,3}),(\d{1,3})\)/

puts instructions.join('').scan(expression).map { |a, b| a.to_i * b.to_i }.sum

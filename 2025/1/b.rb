#!/usr/bin/env ruby
# frozen_string_literal: true

current = 50
count = 0

puts "\t#{current} \t= #{count}"
ARGF.readlines(chomp: true).each do |line|
  print "#{line}"

  case line
  when /^L(\d+)$/
    rotation = Regexp.last_match(1).to_i

    current -= rotation

    count += (current / 100).abs - 1
    count += 1 if current.zero?

    print ' *' if current.zero?

    current %= 100
  when /^R(\d+)$/
    rotation = Regexp.last_match(1).to_i

    current += rotation

    count += (current / 100).abs

    print ' *' if current.zero?

    current %= 100
  end

  puts "\t#{current} \t= #{count}"
end

puts count

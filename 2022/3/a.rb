#!/usr/bin/env ruby
# frozen_string_literal: true

priorities = 0

ARGF.readlines(chomp: true).each do |sack|
  first, second = sack.split(//).each_slice(sack.size/2).to_a

  common, _ = first & second

  priority = case common
             when "a".."z"
               common.ord - "a".ord + 1
             when "A".."Z"
               common.ord - "A".ord + 27
             end

  priorities += priority
end

puts priorities

#!/usr/bin/env ruby
# frozen_string_literal: true

priorities = 0

ARGF.readlines(chomp: true).each_slice(3) do |sacks|
  first, second, third = sacks.map {|sack| sack.split(//)}

  common, _ = first & second & third

  priority = case common
             when "a".."z"
               common.ord - "a".ord + 1
             when "A".."Z"
               common.ord - "A".ord + 27
             end

  priorities += priority
end

puts priorities

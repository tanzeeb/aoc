#!/usr/bin/env ruby
# frozen_string_literal: true

puts ARGF.readlines(chomp: true).sum { |line| 
  line.delete('a-z').chars.values_at(0,-1).join.to_i
}


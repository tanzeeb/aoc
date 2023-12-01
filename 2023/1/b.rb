#!/usr/bin/env ruby
# frozen_string_literal: true

DIGITS = {
    "one" => "1", "two" => "2", "three" => "3",
    "four" => "4", "five" => "5", "six" => "6",
    "seven" => "7", "eight" => "8", "nine" => "9",

    "1" => "1", "2" => "2", "3" => "3",
    "4" => "4", "5" => "5", "6" => "6",
    "7" => "7", "8" => "8", "9" => "9",
  }

puts ARGF.readlines(chomp: true).sum { |line| 
  [
    DIGITS.keys.min_by {|d| line.index(d) || Float::INFINITY },
    DIGITS.keys.max_by {|d| line.rindex(d) || -1 }
  ].map {|d| DIGITS[d]}.compact.join.to_i
}


#!/usr/bin/env ruby
# frozen_string_literal: true

ARGF.readlines(chomp: true).each do |line|
  line.chars.each_cons(4).with_index do |chars, i|
    if chars.uniq.size == chars.size
      puts i+4
      break
    end
  end
end


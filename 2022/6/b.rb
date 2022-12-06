#!/usr/bin/env ruby
# frozen_string_literal: true

N = 14

ARGF.readlines(chomp: true).each do |line|
  line.chars.each_cons(N).with_index do |chars, i|
    if chars.uniq.size == chars.size
      puts i+N
      break
    end
  end
end


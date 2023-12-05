#!/usr/bin/env ruby
# frozen_string_literal: true

h = Hash.new { |h,k| h[k] = [] }

seeds = nil
stack = []

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^seeds:/
    seeds = line.split(/:/).last.strip.split(/ /).map(&:to_i)
  when /^(\w+)-to-(\w+) map:$/
    lookup = $2.to_sym
    stack << lookup

    define_method lookup do |from|
      h[lookup].each do |m|
        return m[:offset] + (from - m[:range].begin) if m[:range].include? from
      end

      from
    end
  when /^(\d+) (\d+) (\d+)$/
    h[stack.last] << { range: $2.to_i..($2.to_i+$3.to_i), offset: $1.to_i }
  end
end

pp seeds.map {|seed| stack.inject(seed) {|a, lookup| send(lookup, a)}}.min

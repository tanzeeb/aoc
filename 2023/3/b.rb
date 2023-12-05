#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

board = ARGF.readlines(chomp: true).map { |line| line.split(//) }

gears = Hash.new do |h,k| 
  h[k] = Set.new
  h[k].compare_by_identity
end

part = nil

board.each.with_index do |line,j|
  line.each.with_index do |c,i|
    if c =~ /[0-9]/
      part ||= { string: "" }

      part[:string] += c

      (-1..1).each do |jp|
        (-1..1).each do |ip|
          cp = board.at(j+jp)&.at(i+ip)

          gears[[i+ip,j+jp]] << part if cp&.match(/\*/)
        end
      end
    else
      part = nil
    end
  end
end

pp gears.select {|_,v| v.size == 2}.map { |k,v| v.map {|s| s[:string].to_i}.inject(:*) }.sum

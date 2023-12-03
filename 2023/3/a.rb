#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

board = ARGF.readlines(chomp: true).map { |line| line.split(//) }

parts = []
part = nil

board.each.with_index do |line,j|
  line.each.with_index do |c,i|
    if c =~ /[0-9]/
      part ||= { string: "", symbols: [] }

      part[:string] += c

      (-1..1).each do |jp|
        (-1..1).each do |ip|
          cp = board.at(j+jp)&.at(i+ip)

          part[:symbols] << cp if cp&.match(/[^.0-9]/)
        end
      end
    else
      parts << part unless part.nil?
      part = nil
    end
  end
end

puts parts.reject { |p| p[:symbols].size == 0 }.sum { |p| p[:string].to_i }

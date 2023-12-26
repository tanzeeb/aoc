#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

@tiles = {}
@start = nil
@max_row = 0
@max_col = 0

ARGF.readlines(chomp: true).each.with_index do |line,row|
  @max_row = row if row > @max_row

  line.split(//).each.with_index do |pipe,col|
    @max_col = col if col > @max_col

    @tiles[ [row,col] ] = pipe
    @start = [row,col] if pipe == "S"
  end
end

def visit tile, from
  row, col = tile
  from_r, from_c = from

  to = []

  case @tiles[tile]
  when '|'
    to << [row-1,col] if from_r == row+1
    to << [row+1,col] if from_r == row-1
  when '-'
    to << [row,col-1] if from_c == col+1
    to << [row,col+1] if from_c == col-1
  when 'L'
    to << [row,col+1] if from_r == row-1
    to << [row-1,col] if from_c == col+1
  when 'J'
    to << [row,col-1] if from_r == row-1
    to << [row-1,col] if from_c == col-1
  when '7'
    to << [row+1,col] if from_c == col-1
    to << [row,col-1] if from_r == row+1
  when 'F'
    to << [row+1,col] if from_c == col+1
    to << [row,col+1] if from_r == row+1
  when '.'
  when 'S'
    to << [row+1,col]
    to << [row-1,col]
    to << [row,col+1]
    to << [row,col-1]
  end

  to
    .reject { |(r,c)| r < 0 || r > @max_row || c < 0 || c > @max_col }
    .map { |t| [t, [row,col]] }
end

current = visit(@start,@start).reject { |t,f| visit(t,f).empty? }
visited = Set[@start]

count = 0

until current.any? {|(s,f)| visited.include? s}
  step = []

  current.each do |(c,f)|
    visited.add c

    visit(c,f).each { |s| step << s }
  end

  count += 1
  current = step
end

pp count

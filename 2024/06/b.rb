#!/usr/bin/env ruby
# frozen_string_literal: true

@map = ARGF.readlines(chomp: true).map { |line| line.split(//) }

@rows = @map.size
@cols = @map.first.size

@obstacles = Hash.new(false)
@path = Hash.new(false)
@pos = nil
@dir = [-1, 0]

@rows.times do |row|
  @cols.times do |col|
    case @map[row][col]
    when '#'
      @obstacles[[row, col]] = true
    when '^'
      @pos = [row, col]
    end
  end
end

def draw
  @rows.times do |row|
    @cols.times do |col|
      print symbol(row, col)
    end
    puts
  end
  puts
end

def symbol(row, col)
  if @obstacles[[row, col]]
    '#'
  elsif @pos.first == row && @pos.last == col
    case @dir
    when [-1, 0]
      '^'
    when [1, 0]
      'v'
    when [0, 1]
      '>'
    when [0, -1]
      '<'
    end
  elsif @path[[row, col]]
    'X'
  else
    '.'
  end
end

def turn!
  @dir = case @dir
         when [-1, 0]
           [0, 1]
         when [0, 1]
           [1, 0]
         when [1, 0]
           [0, -1]
         when [0, -1]
           [-1, 0]
         end
end

def walk!
  forward = [@pos.first + @dir.first, @pos.last + @dir.last]

  if @obstacles[forward]
    turn!
  else
    @path[[@pos, @dir]] = true

    @pos = forward
  end
end

reset_pos = @pos.dup
reset_dir = @dir.dup

count = 0

@rows.times do |row|
  @cols.times do |col|
    next if @obstacles[[row, col]]

    @pos = reset_pos.dup
    @dir = reset_dir.dup
    @path = Hash.new(false)

    @obstacles[[row, col]] = true

    walk! while !@path[[@pos, @dir]] &&
                @pos.first.positive? && @pos.first < @rows && @pos.last.positive? && @pos.last < @cols

    @obstacles.delete [row, col]

    count += 1 if @path[[@pos, @dir]]
  end
end

puts count

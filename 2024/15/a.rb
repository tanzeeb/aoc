#!/usr/bin/env ruby
# frozen_string_literal: true

@map, @moves = ARGF.readlines(chomp: true).slice_before(/^$/).map do |lines|
  lines.reject(&:empty?).map { |l| l.split(//) }
end

@moves.flatten!

@rows = @map.size
@cols = @map.first.size

@dirs = {
  '^' => [-1, 0],
  'v' => [1, 0],
  '<' => [0, -1],
  '>' => [0, 1]
}

@robot = nil
@map.each_with_index do |row, i|
  row.each_with_index do |obj, j|
    if obj == '@'
      @robot = [i, j]
      break
    end
  end
end

def draw
  @map.each do |row|
    row.each do |pos|
      print pos
    end
    puts
  end
  puts
end

def move_to(pos, dir)
  return if @map[pos.first][pos.last] == '#'
  return if @map[pos.first][pos.last] == '.'

  to = [pos.first + dir.first, pos.last + dir.last]

  return if to.first.negative? || to.last.negative? || to.first >= @rows || to.last >= @cols

  move_to to, dir

  return unless @map[to.first][to.last] == '.'

  @robot = to if @robot == pos

  @map[pos.first][pos.last], @map[to.first][to.last] = @map[to.first][to.last], @map[pos.first][pos.last]
end

# puts 'Inital state'
# draw

@moves.each do |move|
  # puts "Move #{move}"

  move_to @robot, @dirs[move]

  # draw
end

sum = 0
@map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next unless col == 'O'

    sum += (100 * i) + j
  end
end

puts sum

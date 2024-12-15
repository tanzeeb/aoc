#!/usr/bin/env ruby
# frozen_string_literal: true

@map, @moves = ARGF.readlines(chomp: true).slice_before(/^$/).map do |lines|
  lines.reject(&:empty?).map { |l| l.gsub('#', '##').gsub('O', '[]').gsub('.', '..').gsub('@', '@.').split(//) }
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

def move?(pos, move)
  obj = @map[pos.first][pos.last]

  return false if obj == '#'
  return true if obj == '.'

  dir = @dirs[move]
  to = [pos.first + dir.first, pos.last + dir.last]

  return move?(to, move) if ['>', '<'].include?(move)

  other = obj == '[' ? [pos.first + dir.first, pos.last + 1] : [pos.first + dir.first, pos.last - 1]

  move?(to, move) && move?(other, move)
end

def move!(pos, move)
  dir = @dirs[move]
  to = [pos.first + dir.first, pos.last + dir.last]
  obj = @map[pos.first][pos.last]

  return if ['#', '.'].include?(obj)

  return unless move? to, move

  move! to, move

  @robot = to if @robot == pos

  if ['^', 'v'].include?(move) && ['[', ']'].include?(obj)
    other_pos = obj == '[' ? [pos.first, pos.last + 1] : [pos.first, pos.last - 1]
    other_to = obj == '[' ? [pos.first + dir.first, pos.last + 1] : [pos.first + dir.first, pos.last - 1]

    move! other_to, move

    @map[other_pos.first][other_pos.last], @map[other_to.first][other_to.last] = \
      @map[other_to.first][other_to.last], @map[other_pos.first][other_pos.last]
  end

  @map[pos.first][pos.last], @map[to.first][to.last] = @map[to.first][to.last], @map[pos.first][pos.last]
end

# puts 'Inital state'
# draw

@moves.each do |move|
  move! @robot, move

  # puts "Move #{move}"
  # draw
end

sum = 0
@map.each_with_index do |row, i|
  row.each_with_index do |col, j|
    next unless col == '['

    sum += (100 * i) + j
  end
end

puts sum

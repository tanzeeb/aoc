#!/usr/bin/env ruby
# frozen_string_literal: true

steps = 2

algorithm = ARGF.readline.chomp.split('')

ARGF.readline

image = ARGF.readlines(chomp: true).map { |line| line.split('') }
canvas = '.'

def resolve algorithm, pixels
  index = pixels.map {|c| c == '#' ? '1' : '0' }.join("").to_i(2)

  algorithm[index]
end

def enhance algorithm, image, canvas
  max_x = image.first.size-1
  max_y = image.size-1

  lookup = Hash.new do |_,(x,y)|
    if x < 0 || x > max_x || y < 0 || y > max_y
      canvas
    else
      image[x][y]
    end
  end

  new_canvas = resolve algorithm, [canvas]*9

  new_image = (-2..max_y+2).map do |y|
    (-2..max_x+2).map do |x|
      pixels = (y-1..y+1).map {|cx| (x-1..x+1).map {|cy| lookup[[cx,cy]]}}.flatten

      resolve algorithm, pixels
    end
  end

  return new_image, new_canvas
end

steps.times do
  image, canvas = enhance algorithm, image, canvas
end

if canvas == '.'
  puts image.flatten.count {|i| i == '#'}
else
  puts "Infinity"
end

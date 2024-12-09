#!/usr/bin/env ruby
# frozen_string_literal: true

@disk = []

ARGF.readline(chomp: true).split(//).each_slice(2).with_index do |(file, space), id|
  file.to_i.times { @disk << id.to_i }
  space.to_i.times { @disk << nil }
end

def draw
  @disk.each { |block| print block.nil? ? '.' : block }
  puts
end

@start = 0
@end = @disk.size - 1

while @start < @end
  if @disk[@start]
    @start += 1
    next
  end

  unless @disk[@end]
    @end -= 1
    next
  end

  @disk[@start], @disk[@end] = @disk[@end], @disk[@start]
end

checksum = 0

@disk.each_with_index do |block, i|
  next unless block

  checksum += block * i
end

puts checksum

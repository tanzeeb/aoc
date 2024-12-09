#!/usr/bin/env ruby
# frozen_string_literal: true

@disk = []
@sizes = Hash.new(0)

ARGF.readline(chomp: true).split(//).each_slice(2).with_index do |(file, space), id|
  file.to_i.times { @disk << id.to_i }
  space.to_i.times { @disk << nil }

  @sizes[id.to_i] = file.to_i
end

def draw
  @disk.each { |block| print block.nil? ? '.' : block }
  puts
end

@start = 0
@end = @disk.size - 1

while @end >= 0
  if @disk[@start]
    @start += @sizes[@disk[@start]]
    next
  end

  unless @disk[@end]
    @end -= 1
    next
  end

  if @start > @end
    @start = 0
    @end -= @sizes[@disk[@end]]
    next
  end

  offset = @sizes[@disk[@end]] - 1
  space = (@start..(@start + offset))
  file = ((@end - offset)..@end)

  if @disk[space].all?(&:nil?)
    @disk[space], @disk[file] = @disk[file], @disk[space]

    @start = 0
  else
    @start += 1
  end
end

checksum = 0

@disk.each_with_index do |block, i|
  next unless block

  checksum += block * i
end

puts checksum

#!/usr/bin/env ruby
# frozen_string_literal: true

octopi = ARGF.readlines.map { |line| line.chomp.split("").map(&:to_i) }

max_i = octopi.first.size-1
max_j = octopi.size-1

count = 0

until octopi.all? { |rows| rows.all? { |e| e == 0 } } 
  flashers = []

  octopi.each_with_index do |row, i|
    row.each_with_index do |energy, j|
      octopi[i][j] = energy + 1

      flashers << [i,j] if energy == 9
    end
  end

  until flashers.empty?
    fi, fj = flashers.shift

    ([0,fi-1].max..[max_i,fi+1].min).each do |i|
      ([0,fj-1].max..[max_j,fj+1].min).each do |j|
        unless i == fi && j == fj
          energy = octopi[i][j]
          
          octopi[i][j] = energy + 1

          flashers << [i,j] if energy == 9
        end
      end
    end
  end

  octopi.each_with_index do |row, i|
    row.each_with_index do |energy, j|
      octopi[i][j] = 0 if energy > 9
    end
  end

  count += 1
end

puts count

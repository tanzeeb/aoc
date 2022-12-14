#!/usr/bin/env ruby
# frozen_string_literal: true

ordered = []

def cmp l, r
  left = l.dup
  right = r.dup

  case [left, right]
  in [Array, Array]
    return 0 if left.empty? && right.empty?
    return -1 if left.empty?
    return 1 if right.empty?

    nl = left.shift
    nr = right.shift
    c = cmp(nl, nr)

    while c == 0
      return 0 if left.empty? && right.empty?
      return -1 if left.empty?
      return 1 if right.empty?

      nl = left.shift
      nr = right.shift
      c = cmp(nl, nr)
    end

    return c
  in [Integer, Integer]
    if left < right
      return -1
    elsif right < left
      return 1
    else
      return 0
    end
  in [Array, Integer]
    return cmp left, [right]
  in [Integer, Array]
    return cmp [left], right
  end
end

p1 = [[2]]
p2 = [[6]]

packets = [p1,p2]

ARGF.readlines(chomp: true).each do |line|
  packets << eval(line) unless line == ""
end

packets.sort! { |left, right| cmp(left,right) }

p1_i = packets.find_index(p1) + 1
p2_i = packets.find_index(p2) + 1

puts p1_i * p2_i

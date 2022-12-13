#!/usr/bin/env ruby
# frozen_string_literal: true

ordered = []

def cmp left, right
  case [left, right]
  in [Array, Array]
    return 0 if left.empty? && right.empty?
    return 1 if left.empty?
    return -1 if right.empty?

    nl = left.shift
    nr = right.shift
    c = cmp(nl, nr)

    while c == 0
      return 0 if left.empty? && right.empty?
      return 1 if left.empty?
      return -1 if right.empty?

      nl = left.shift
      nr = right.shift
      c = cmp(nl, nr)
    end

    return c
  in [Integer, Integer]
    if left < right
      return 1
    elsif right < left
      return -1
    else
      return 0
    end
  in [Array, Integer]
    return cmp left, [right]
  in [Integer, Array]
    return cmp [left], right
  end
end

ARGF.readlines(chomp: true).each_slice(3).with_index do |(left,right,_),i|
  ordered << i+1 if cmp(eval(left),eval(right)) == 1
end

puts ordered.sum

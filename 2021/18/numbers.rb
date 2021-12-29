#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

def sum left, right
  reduce [left,right]
end

def split number
  left = number.first
  right = number.last

  if left.kind_of? Integer
    return [[ (left/2.0).floor.to_i, (left/2.0).ceil.to_i ], right] if left > 9
  else
    split_left = split left

    return [split_left, right] if split_left != left
  end

  if right.kind_of?(Integer) 
    return [left, [ (right/2.0).floor.to_i, (right/2.0).ceil.to_i ]] if right > 9
  else
    split_right = split right

    return [left, split_right] if split_right != right
  end

  return number
end

def carry_left number, carry
  if carry != nil
    number.kind_of?(Integer) ? number + carry : [number.first, carry_left(number.last, carry)]
  else
    number
  end
end

def carry_right number, carry
  if carry != nil
    number.kind_of?(Integer) ? number + carry : [carry_right(number.first, carry), number.last]
  else
    number
  end
end

def explode number, nest = 1
  left = number.first
  right = number.last

  if left.kind_of?(Integer) && right.kind_of?(Integer) && nest > 4
    return 0, number
  else
    if left.kind_of?(Array)
      new_left, carry = explode left, nest + 1

      if new_left != left
        new_right = carry_right right, carry.last
        
        return [new_left,new_right], [carry.first, nil]
      end
    end

    if right.kind_of?(Array)
      new_right, carry = explode right, nest + 1

      if new_right != right
        new_left = carry_left left, carry.first

        return [new_left,new_right], [nil, carry.last] 
      end
    end
  end

  return number, [nil, nil]
end

def reduce number
  loop do
    new_number,_ = explode number

    if new_number != number
      number = new_number
      next
    end

    new_number = split number
    if new_number != number
      number = new_number
      next
    end

    return number
  end
end

def magnitude number
  left, right = number.map { |n| n.kind_of?(Array) ? magnitude(n) : n }

  left*3 + right*2
end

numbers = ARGF.readlines(chomp: true).map do |line|
  JSON.parse line
end

puts magnitude numbers.inject { |l,r| sum l, r }


#!/usr/bin/env ruby
# frozen_string_literal: true

puts "-"*10

numbers = ARGF.readlines(chomp: true).map { |l| l.split(//) }

def decimal digits
  power = 0
  num = 0

  digits.reverse.each do |digit|
    n = 5**power

    num += case digit
            when "-"
              -1 * n
            when "="
              -2 * n
            else
              digit.to_i * n
            end

    power += 1
  end

  num
end

def snafu number
  remainder = number.to_s(5).split(//)
  wip = []

  until remainder.empty?
    d = remainder.pop

    case d
    when "0"
      wip << d
    when "1"
      wip << d
    when "2"
      wip << d
    when "3"
      wip << "="

      remainder = remainder.join("").to_i(5).succ.to_s(5).split(//)
    when "4"
      wip << "-"

      remainder = remainder.join("").to_i(5).succ.to_s(5).split(//)
    end
  end

  wip.reverse.join("") 
end

decimal_sum = numbers.sum {|digits| decimal(digits) }
snafu_sum = snafu decimal_sum

puts snafu_sum

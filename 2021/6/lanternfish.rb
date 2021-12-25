#!/usr/bin/env ruby
# frozen_string_literal: true

fish = ARGF.readline.chomp.split(",").map(&:to_i)

80.times do
  new = []

  fish.map! do |timer|
    if timer == 0
      new << 8
      6
    else
      timer - 1
    end
  end

  fish += new
end

pp fish.size

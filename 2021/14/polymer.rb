#!/usr/bin/env ruby
# frozen_string_literal: true

STEPS = 10

template = ARGF.readline.chomp.split("")

ARGF.readline

rules = {}

ARGF.readlines(chomp: true).each do |line|
  pair, element = line.split(/ -> /)

  rules[ pair.split("") ] = element
end

polymer = template

STEPS.times do |step|
  new = []

  polymer.each_cons(2) do |(a,b)|
    new << a
    new << rules[[a,b]]
  end

  new << polymer.last

  polymer = new
end

counts = Hash.new(0)

polymer.each do |element|
  counts[element] += 1
end

min,max = counts.values.minmax

puts max - min

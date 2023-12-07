#!/usr/bin/env ruby
# frozen_string_literal: true

file = ARGF.readlines(chomp: true)

times = file.first.split(":").last.strip.split(/\W+/).map(&:to_i)
distances = file.last.split(":").last.strip.split(/\W+/).map(&:to_i)

races = times.zip(distances)

pp races.map { |(t,d)|
  x1 = (t - Math.sqrt(t*t - 4*d))/2.0 
  x2 = (t + Math.sqrt(t*t - 4*d))/2.0 

  ( (x1.ceil==x1 ? x1.ceil+1 : x1.ceil) .. (x2.floor==x2 ? x2.floor-1 : x2.floor) ).size
}.inject(&:*)


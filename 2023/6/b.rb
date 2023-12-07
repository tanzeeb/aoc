#!/usr/bin/env ruby
# frozen_string_literal: true

file = ARGF.readlines(chomp: true)

t = file.first.split(":").last.gsub(" ","").to_i
d = file.last.split(":").last.gsub(" ","").to_i

x1 = (t - Math.sqrt(t*t - 4*d))/2.0 
x2 = (t + Math.sqrt(t*t - 4*d))/2.0 

pp ( (x1.ceil==x1 ? x1.ceil+1 : x1.ceil) .. (x2.floor==x2 ? x2.floor-1 : x2.floor) ).size


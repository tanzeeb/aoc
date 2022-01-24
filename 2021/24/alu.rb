#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

code = ARGF.readlines(chomp: true).map do |line|
  line.split(' ')
end

def compile name, code
  program = []
  program << "def #{name} w, z"
  program << "x=0"
  program << "y=0"

  code.each do |(ins,reg,param)|
    case ins
    when "add"
      program << "#{reg} += #{param}"
    when "mul"
      program << "#{reg} *= #{param}"
    when "div"
      program << "#{reg} /= #{param}"
    when "mod"
      program << "#{reg} %= #{param}"
    when "eql"
      program << "#{reg} = #{param} == #{reg} ? 1 : 0"
    end
  end

  program << "z"
  program << "end"

  return program.join("\n")
end

code.slice_before { |(ins,*_)| ins == "inp" }.each_with_index do |c, i|
  eval compile("digit_#{i+1}", c)
end

def weight state
  state[0] * (10**(14-state[1]))
end

q = Set[]
dist = Hash.new(-1)
qdist = {}
prev = {}
discard = Set[]

last = nil

(1..9).each do |i|
  state = [i,1,digit_1(i,0)]
  w = weight(state)

  q << state
  dist[state] = w
  qdist[state] = w
end

until q.empty?
  u = qdist.max_by {|_,v| v}.first

  q.delete u
  qdist.delete u
  discard << u

  if u[1] == 14 
    if u[2] == 0
      last = u
      break
    else
      next
    end
  end

  (1..9).map do |i|
    d = u[1]+1
    z = u[2]

    [i,d,send(:"digit_#{d}",i,z)]
  end.each do |v|
    alt = dist[u] + weight(v)

    if alt > dist[v]
      q.add v
      dist[v] = alt
      qdist[v] = alt
      prev[v] = u
    end
  end
end

digits = []
until last.nil?
  digits << last[0]
  last = prev[last]
end

puts digits.reverse.map(&:to_s).join("")

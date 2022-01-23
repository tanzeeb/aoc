#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

@levels = {
  'A' => 1,
  'B' => 10,
  'C' => 100,
  'D' => 1000,
}

@spots = [
  [0,0],[1,0],      [3,0],      [5,0],      [7,0],      [9,0],[10,0],
              [2,1],      [4,1],      [6,1],      [8,1],
              [2,2],      [4,2],      [6,2],      [8,2],
]

start = {}
@target = {
  [2,1] => 'A',
  [2,2] => 'A',
  [4,1] => 'B',
  [4,2] => 'B',
  [6,1] => 'C',
  [6,2] => 'C',
  [8,1] => 'D',
  [8,2] => 'D',
}


ARGF.readlines.join('').split('').filter {|c| c =~ /[A-D]/}.each_slice(4).with_index do |row,j|
  row.each_with_index do |amphipod, i|
    start[[i*2+2,j+1]] = amphipod
  end
end

def draw burrow
  3.times do |y|
    11.times do |x|
      if burrow[[x,y]]
        putc burrow[[x,y]]
      else
        putc ' '
      end
    end
    puts ""
  end
  puts ""
end

def hallway to, from
  @spots.select { |(x,y)| [ y == 0, x > [from[0],to[0]].min, x < [from[0],to[0]].max, ].all? }
end

def moves burrow
  all = []

  burrow.each do |from, amphipod|
    next if from[1] == 2 && burrow[[from[0],1]]
    next if from[1] == 2 && burrow[from] == @target[from]
    next if from[1] == 1 && burrow[from] == @target[from] && burrow[[from[0],2]] == @target[[from[0],2]]

    @spots.each do |to|
      next if burrow[to]
      next if from[1] == 0 && to[1] == 0
      next if from[0] == to[0] && to[1] > 0
      next if from[1] == 2 && burrow[[from[0],1]]
      next if to[1] > 0 && @target[to] != amphipod
      next if to[1] == 1 && burrow[[to[0],2]] != @target[[to[0],2]]
      next if hallway(to,from).any? {|spot| burrow[spot]}

      all << [amphipod,from,to]
    end
  end

  all
end

def step burrow, move
  amphipod, from, to = move

  burrow.merge(to => amphipod, from => nil).compact
end

def energy move
  amphipod, from, to = move

  e = (from[0] - to[0]).abs
  e += from[1] + to[1] if e > 0
  e *= @levels[amphipod]

  e
end

def ideal burrow
  t = @target.dup

  burrow.map do |from,amphipod|
    to, _ = t.find { |_,v| v == amphipod }

    t.delete to

    energy [amphipod, from, to]
  end.sum
end

q = Set[start]

dist = Hash.new(Float::INFINITY)
dist[start] = 0

goal = Hash.new(Float::INFINITY)
goal[start] = ideal start

discard = Set[]

until q.empty?
  u = goal.min_by {|_,v| v}.first

  q.delete u
  goal.delete u
  discard << u

  break if u == @target

  moves(u).each do |move|
    alt = dist[u] + energy(move)
    v = step(u, move)

    next if discard.include?(v)

    if alt < dist[v]
      q.add v
      i = ideal(v)
      dist[v] = alt
      goal[v] = alt + i
    end
  end
end

puts dist[@target]

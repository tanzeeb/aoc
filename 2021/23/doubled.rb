#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'io/console'

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
              [2,3],      [4,3],      [6,3],      [8,3],
              [2,4],      [4,4],      [6,4],      [8,4],
]

start = {
  [2,2] => 'D', [4,2] => 'C', [6,2] => 'B', [8,2] => 'A',
  [2,3] => 'D', [4,3] => 'B', [6,3] => 'A', [8,3] => 'C',
}

@target = {
  [2,1] => 'A', [4,1] => 'B', [6,1] => 'C', [8,1] => 'D',
  [2,2] => 'A', [4,2] => 'B', [6,2] => 'C', [8,2] => 'D',
  [2,3] => 'A', [4,3] => 'B', [6,3] => 'C', [8,3] => 'D',
  [2,4] => 'A', [4,4] => 'B', [6,4] => 'C', [8,4] => 'D',
}


ARGF.readlines.join('').split('').filter {|c| c =~ /[A-D]/}.each_slice(4).with_index do |row,j|
  row.each_with_index do |amphipod, i|
    start[[i*2+2,j*3+1]] = amphipod
  end
end

def draw burrow
  5.times do |y|
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

def above room, row
  @spots.select { |(x,y)| x == room && y < row }
end

def below room, row
  @spots.select { |(x,y)| x == room && y > row }
end

def moves burrow
  all = []
  
  burrow.each do |from, amphipod|
    next if from[1] > 1 && above(*from).any? { |spot| burrow[spot] }
    next if from[1] > 0 && below(from[0],from[1]-1).all? { |spot| burrow[spot] == @target[spot] }

    @spots.each do |to|
      next if burrow[to]
      next if from[1] == 0 && to[1] == 0
      next if from[0] == to[0] && to[1] > 0
      next if to[1] > 0 && @target[to] != amphipod
      next if to[1] > 0 && above(*to).any? { |spot| burrow[spot] }
      next if to[1] > 0 && below(*to).any? { |spot| burrow[spot] != @target[spot] }
      next if hallway(to,from).any? {|spot| burrow[spot]}

      all << [amphipod,from,to]
    end
  end

  rooms = all.select { |_,_,(_,y)| y > 0 }

  rooms.empty? ? all : rooms
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
  b = burrow.dup

  sames = b.select { |k,v| t[k] == v && below(*k).all? {|s| t[s] == b[s]} }
  sames.each do |spot,_|
    t.delete spot
    b.delete spot
  end

  b.map do |from,amphipod|
    to, _ = t.find { |_,v| v == amphipod }

    t.delete to

    energy [amphipod, from, to]
  end.sum
end

def completion burrow
  sum = 0

  @target.each do |spot,amphipod|
    unless [
      burrow[spot] == amphipod,
      above(*spot).all? {|s| burrow[s] == amphipod || burrow[s].nil?},
      below(*spot).all? {|s| burrow[s] == amphipod}
    ].all?
      sum += spot[1]*1000 
    end

    sum += @levels[amphipod] if burrow[spot].nil?
  end

  sum
end

q = Set[start]

dist = Hash.new(Float::INFINITY)
dist[start] = 0

goal = Hash.new(Float::INFINITY)
goal[start] = ideal start

count = 0

IO::console.clear_screen

until q.empty?
  IO::console.goto(0,0)

  u = q.min {|a,b| goal[a] <=> goal[b]}
  #pp q.map {|b| goal[b]}
  count += 1
  #break if count > 2

  q.delete u

  draw u
  puts "#q: #{q.size} dist: #{dist[u]} - diff: #{goal[u] - dist[u]}"

  break if u == @target

  m = moves(u)
  m.each do |move|
    alt = dist[u] + energy(move)
    v = step(u, move)

    if alt < dist[v]
      q.add v
      dist[v] = alt

      i = ideal(v)
      c = completion(v)
      goal[v] = alt + i

      #puts "#{move.inspect} - #{i} - #{c} - #{alt}"
    end
  end
end

puts dist[@target]

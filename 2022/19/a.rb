#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

TYPES = [:ore, :clay, :obsidian, :geode]

Blueprint = Struct.new(:id, :ore, :clay, :obsidian, :geode) do
  def builds robots, inventory
    bs = Set[]

    queue = [[robots.dup, inventory.dup]]

    while build = queue.pop
      bs << build
      r,i = build

      TYPES.each do |type|
        count = self[type].how_many? i

        count.times do |n|
          n = [r.dup.add!(type, n+1), i.dup.deduct!(self[type], n+1)]

          queue << n unless bs.include? n
        end
      end
    end

    bs
  end
end

Cost = Struct.new(*TYPES) do
  def how_many? inventory
    TYPES.select {|t| self[t] > 0 }.map do |type|
      inventory[type] / self[type]
    end.min
  end
end

Inventory = Struct.new(*TYPES) do
  def collect! robots
    TYPES.each do |type|
      self[type] += robots[type]
    end

    self
  end

  def deduct! cost, count
    TYPES.each do |type|
      self[type] -= cost[type] * count
    end

    self
  end
end

Robots = Struct.new(*TYPES) do
  def add! type, count
    self[type] += count

    self
  end
end

blueprints = []

ARGF.readlines(chomp: true).each do |line|
  blueprint = Blueprint.new

  line.split(/[:.]/).each do |part|
    case part.strip
    when /Blueprint (\d+)/
      blueprint.id = $1.to_i
    when /Each ore robot costs (\d+) ore/
      blueprint.ore = Cost.new($1.to_i,0,0,0)
    when /Each clay robot costs (\d+) ore/
      blueprint.clay = Cost.new($1.to_i,0,0,0)
    when /Each obsidian robot costs (\d+) ore and (\d+) clay/
      blueprint.obsidian = Cost.new($1.to_i, 0, $2.to_i, 0)
    when /Each geode robot costs (\d+) ore and (\d+) obsidian/
      blueprint.geode = Cost.new($1.to_i, 0, 0, $2.to_i,)
    end
  end

  blueprints << blueprint
end

def geodes blueprint, robots, inventory, minutes
  return inventory.geode if minutes < 1

  inventory.collect! robots

  options = blueprint.builds robots, inventory

  options.map {|(r,i)| geodes(blueprint,r,i,minutes-1)}.max
end

pp geodes(blueprints.first, Robots.new(1,0,0,0), Inventory.new(0,0,0,0), 24)

#puts blueprints.map {|b| geodes(b, Robots.new(0,0,0,0), Inventory.new(0,0,0,0), 24) * b.id}.sum

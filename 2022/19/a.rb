#!/usr/bin/env ruby
# frozen_string_literal: true

Blueprint = Struct.new(:id, :ore, :clay, :obsidian, :geode)
Ore = Struct.new(:ore)
Clay = Struct.new(:ore)
Obsidian = Struct.new(:ore, :clay)
Geode = Struct.new(:ore, :obsidian)

Inventory = Struct.new(:ore, :clay, :obsidian, :geode)
Robots = Struct.new(:ore, :clay, :obsidian, :geode)

blueprints = []

ARGF.readlines(chomp: true).each do |line|
  blueprint = Blueprint.new

  line.split(/[:.]/).each do |part|
    case part.strip
    when /Blueprint (\d+)/
      blueprint.id = $1.to_i
    when /Each ore robot costs (\d+) ore/
      blueprint.ore = Ore.new($1.to_i)
    when /Each clay robot costs (\d+) ore/
      blueprint.clay = Clay.new($1.to_i)
    when /Each obsidian robot costs (\d+) ore and (\d+) clay/
      blueprint.obsidian = Obsidian.new($1.to_i, $2.to_i)
    when /Each geode robot costs (\d+) ore and (\d+) obsidian/
      blueprint.geode = Geode.new($1.to_i, $2.to_i)
    else
    end
  end

  blueprints << blueprint
end

def collect! robots, inventory
  inventory.ore += robots.ore
  inventory.clay += robots.clay
  inventory.obsidian += robots.obsidian
  inventory.geode += robots.geode
end

def builds blueprint, robots, inventory

end

def geodes blueprint, robots, inventory, minutes
  return inventory.geodes if minutes < 1

  collect! robots, inventory

  options = builds blueprint, robots, inventory

  options.map {|(r,i)| geodes(blueprint,r,i,minutes-1)}.max
end


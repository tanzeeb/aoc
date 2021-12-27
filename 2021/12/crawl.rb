#!/usr/bin/env ruby
# frozen_string_literal: true

def crawl caves, paths, path
  if path.last == "end"
    paths << path
  else
    caves[path.last].each do |cave|
      next if cave == "start"
      if cave.upcase != cave && cave != "end"
        small = path.select {|c| c.downcase == c}.sort

        next if small.uniq != small && path.count(cave) > 0
      end

      crawl caves, paths, path + [cave]
    end
  end
end

caves = {}

ARGF.readlines.each do |line|
  entry = line.chomp.split("-")

  [entry, entry.reverse].each do |a,b|
    if caves.has_key? a
      caves[a] << b
    else
      caves[a] = [b]
    end
  end
end

paths = []

crawl caves, paths, ["start"]

puts paths.count

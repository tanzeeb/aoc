#!/usr/bin/env ruby
# frozen_string_literal: true

def crawl caves, paths, path
  if path.last == "end"
    paths << path
  else
    caves[path.last].each do |cave|
      next if path.include?(cave) && cave.upcase != cave 

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

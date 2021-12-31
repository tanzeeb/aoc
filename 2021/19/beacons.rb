#!/usr/bin/env ruby
# frozen_string_literal: true

report = []

current = nil

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^--- scanner \d+ ---$/
    current = []
  when /^$/
    report << current
  else
    current << line.split(',').map(&:to_i)
  end
end

report << current unless current.empty?

def distances scanner
  scanner.map do |source|
    scanner.map do |target|
      source.zip(target).map {|(a,b)| (a-b)**2 }.sum
    end
  end
end

def match a, b, threshold
  ad = distances a
  bd = distances b

  pair = (0...a.size).to_a.product((0...b.size).to_a).find do |(ai,bi)|
    (ad[ai] & bd[bi]).size >= threshold
  end

  return unless pair

  directions = [1,1,1,-1,-1,-1].permutation(3).uniq
  orientations = [0,1,2].permutation(3).uniq

  orientations.product(directions).each do |(orientation,direction)|
    translation = (0..2).map { |i| a[pair.first][i] - direction[i] * b[pair.last][orientation[i]] }

    beacons = b.map do |beacon|
      (0..2).map { |i| translation[i] + direction[i] * beacon[orientation[i]] }
    end

    return beacons if (a & beacons).size >= threshold
  end

  nil
end

scanners = Marshal.load(Marshal.dump(report))
beacons = scanners.shift

counter = scanners.size

until scanners.empty?
  scanner = scanners.shift

  matches = match(beacons, scanner, [12,scanner.size].min)

  if matches
    beacons.concat matches
    beacons.uniq!

    counter = scanners.size
  else
    scanners << scanner

    counter -= 1

    throw "no matches" if counter < 0
  end
end

puts beacons.size

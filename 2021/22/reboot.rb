#!/usr/bin/env ruby
# frozen_string_literal: true

steps = ARGF.readlines(chomp: true).map do |line|
  direction, ranges = line.split(' ')

  [direction == 'on', ranges.split(',').map { |r| Range.new *r.split('=').last.split('..').map(&:to_i) }]
end

def volume box
  box.reduce(1) { |volume, side| volume * side.size }
end

def split target, source
  (0..2).map do |i|
    [
      [target[i].min,source[i].min].min...[target[i].min,source[i].min].max,
      [target[i].min,source[i].min].max..[target[i].max,source[i].max].min,
      [target[i].max,source[i].max].min.next..[target[i].max,source[i].max].max,
    ]
  end.inject(&:product).map(&:flatten).select do |box|
    overlap? source, box
  end.reject do |box|
    overlap? target, box
  end.reject do |box|
    volume(box) == 0
  end
end

def overlap? target, source
  [
    target[0].cover?(source[0].first) || source[0].cover?(target[0].first),
    target[1].cover?(source[1].first) || source[1].cover?(target[1].first),
    target[2].cover?(source[2].first) || source[2].cover?(target[2].first),
  ].all?
end

def extrude target, boxes 
  overlapping, clear = boxes.partition {|source| overlap? target, source}

  overlapping.each do |source|
    cleared = split target, source

    clear += cleared
  end

  clear
end

boxes = []

steps.each do |(add,(xs,ys,zs))|
  box = [xs,ys,zs]

  boxes = extrude box, boxes
  boxes << box if add
end

puts boxes.sum {|box| volume box }

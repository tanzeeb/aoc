#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

puts "---"

Valley = Struct.new(:start) do
  def state minute=0
    @states ||= Hash.new do |s,m|
      s[m] = if m == 0
               points = {}
               start.each.with_index do |line, y|
                 line.each.with_index do |pos, x|
                   points[[x,y]] = [pos] unless pos == "."
                 end
               end

               State.new(points, start.size, start.first.size)
             else
               s[m.pred].next
             end
    end

    @states[minute]
  end

  def entrance
    @entrance ||= [start.first.index("."), 0]
  end

  def exit
    @exit ||= [start.last.index("."), start.size.pred]
  end

  def draw minute=0
    puts "\nMinute #{minute}:"
    state(minute).draw
  end

  def travel_time
    queue = [[0, entrance]]
    visited = Set[[0, entrance]]

    current = nil

    until queue.empty?
      current = queue.shift

      break if current.last == self.exit

      minute = current.first + 1

      state(minute).empties(*current.last).each do |position|
        candidate = [minute, position]

        next if visited.include? candidate

        visited << candidate
        queue << candidate
      end
    end

    current.first
  end
end

State = Struct.new(:points, :h, :w) do
  def empties x, y
    [
      [x,y],
      [x+1,y],
      [x-1,y],
      [x,y+1],
      [x,y-1],
    ].reject { |(nx,ny)| nx < 0 || nx > w-1 || ny < 0 || ny > h-1 || points[[nx,ny]] }
  end

  def next
    new, blizzards = points.partition { |_,vs| vs.size == 1 && vs.first == "#" }.map(&:to_h)

    new.default_proc = proc { |h,k| h[k] = [] }

    blizzards.each do |(x,y),vs|
      vs.each do |v|
        case v
        when "<"
          nx = x == 1 ? w-2 : x-1
          new[[nx,y]] << v
        when ">"
          nx = x == w-2 ? 1 : x+1
          new[[nx,y]] << v
        when "^"
          ny = y == 1 ? h-2 : y-1
          new[[x,ny]] << v
        when "v"
          ny = y == h-2 ? 1 : y+1
          new[[x,ny]] << v
        end
      end
    end

    new.default_proc = nil

    State.new(new, h, w)
  end

  def map
    h.times.map do |y|
      w.times.map do |x|
        v = points[[x,y]]

        if v.nil?
          "."
        elsif v.size > 1
          v.size.to_s
        else
          v
        end
      end
    end
  end

  def draw
    puts map.map { |line|
      line.join("")
    }.join("\n")
  end
end

map = ARGF.readlines(chomp: true).map do |line|
  line.split(//)
end

valley = Valley.new(map)

puts valley.travel_time

#!/usr/bin/env ruby
# frozen_string_literal: true

Node = Struct.new(:v,:p,:n) do
  def move count
    return if count == 0

    self.p.n = self.n
    self.n.p = self.p

    if count > 0
      n = self.n
      count.times { n = n.n }

      self.p = n.p
      self.p.n = self

      n.p = self
      self.n = n
    end

    if count < 0
      p = self.p
      count.abs.times { p = p.p }

      self.n = p.n
      self.n.p = self

      p.n = self
      self.p = p
    end
  end

  def to_s
    { value: self.v, prev: self.p.v, next: self.n.v }.to_s
  end

  def to_a
    list = [self.v]

    current = self
    list << current.v until (current = current.n) == self

    list
  end
end

file = ARGF.readlines(chomp: true).map { |n| Node.new(n.to_i,nil,nil) }

file.first.p = file.last
file.last.n = file.first

file.each_cons(2) do |p,n|
  p.n = n
  n.p = p
end


def mix file
  file.each do |node|
    node.move(node.v)
  end
end

mix file

zero = file.find {|n| n.v == 0}.to_a

puts [1000,2000,3000].map {|n| zero[n%zero.size] }.sum

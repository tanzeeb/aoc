#!/usr/bin/env ruby
# frozen_string_literal: true

histories = ARGF.readlines(chomp: true).map { |l| l.split(" ").map(&:to_i) }

def prediction history
  return 0 if history.all? &:zero?

  history.last + prediction(diff(history))
end

def diff history
  [].tap { |d| history.each_cons(2) { |a,b| d.push(b-a) } }
end

pp histories.sum { |h| prediction(h) }


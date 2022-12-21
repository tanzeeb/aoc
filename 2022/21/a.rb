#!/usr/bin/env ruby
# frozen_string_literal: true

monkeys = {}

Number = Struct.new(:value) do
end

Operation = Struct.new(:op, :a, :b, :monkeys) do
  def value
    a = self.monkeys[self.a]
    b = self.monkeys[self.b]

    a.value.send(self.op, b.value)
  end
end

ARGF.readlines(chomp: true).each do |line|
  name, job = line.split(/:/)

  monkeys[name] = case job
                  when /\d+/
                    Number.new(job.to_i)
                  when /(\w+) ([+\-*\/]) (\w+)/
                    Operation.new($2.to_sym, $1, $3, monkeys)
                  end
end

puts monkeys["root"].value

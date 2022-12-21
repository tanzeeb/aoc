#!/usr/bin/env ruby
# frozen_string_literal: true

monkeys = {}

Number = Struct.new(:value) do
  def to_s
    self.value.to_s
  end

  def unknown?
    false
  end
end

class Unknown
  def value
    raise "unknown"
  end

  def unknown?
    true
  end

  def unwrap v
    v
  end

  def to_s
    "_"
  end
end

Operation = Struct.new(:op, :a_ref, :b_ref, :monkeys) do
  def a
    self.monkeys[self.a_ref]
  end

  def b
    self.monkeys[self.b_ref]
  end

  def value
    self.a.value.send(self.op, self.b.value)
  end

  def to_s
    "(#{self.a} #{self.op} #{self.b})"
  end

  def unwrap v
    raise "can't negate equation" if self.op == "=".to_sym

    if a.unknown?
      case self.op.to_s
      when "+"
        a.unwrap v.send("-".to_sym, b.value)
      when "-"
        a.unwrap v.send("+".to_sym, b.value)
      when "*"
        a.unwrap v.send("/".to_sym, b.value)
      when "/"
        a.unwrap v.send("*".to_sym, b.value)
      end
    else
      case self.op.to_s
      when "+"
        b.unwrap v.send("-".to_sym, a.value)
      when "-"
        b.unwrap a.value.send("-".to_sym, v)
      when "*"
        b.unwrap v.send("/".to_sym, a.value)
      when "/"
        b.unwrap a.value.send("/".to_sym, v)
      end
    end
  end

  def unknown?
    a.unknown? || b.unknown?
  end

  def solve
    raise "can't solve expression" unless self.op == "=".to_sym

    a.unknown? ? a.unwrap(b.value) : b.unwrap(a.value)
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

monkeys["humn"] = Unknown.new
monkeys["root"].op = "=".to_sym

puts monkeys["root"].solve

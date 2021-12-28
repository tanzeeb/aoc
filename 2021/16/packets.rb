#!/usr/bin/env ruby
# frozen_string_literal: true

def parse transmission
  version = transmission[0..2].to_i(2)
  type = transmission[3..5].to_i(2)
  value = nil
  packets = []
  remainder = transmission[6..]

  case type
  when 4
    bits = ""

    loop do
      cont = remainder[0] == "1"
      bits += remainder[1..4]
      remainder = remainder[5..]

      break unless cont
    end

    value = bits.to_i(2)
  else
    case remainder[0]
    when "0"
      length = remainder[1..15].to_i(2)
      remainder = remainder[16..]
      leftover = remainder.size - length
      
      while remainder.size > leftover
        packet, remainder = parse remainder
        packets << packet
      end
    when "1"
      count = remainder[1..11].to_i(2)
      remainder = remainder[12..]

      count.times do 
        packet, remainder = parse remainder
        packets << packet
      end
    end

    case type
    when 0
      value = packets.inject(0) {|sum, p| sum += p[:value]}
    when 1
      value = packets.inject(1) {|product, p| product *= p[:value]}
    when 2
      value = packets.map {|p| p[:value]}.min
    when 3
      value = packets.map {|p| p[:value]}.max
    when 5
      value = packets[0][:value] > packets[1][:value] ? 1 : 0
    when 6
      value = packets[0][:value] < packets[1][:value] ? 1 : 0
    when 7
      value = packets[0][:value] == packets[1][:value] ? 1 : 0
    end
  end

  return { version: version, type: type, value: value, packets: packets }, remainder
end

ARGF.readlines(chomp: true).map do |line|
  transmission = line.split("").map { |h| "%04b" % h.to_i(16) }.join("")

  packet, remainder = parse transmission

  puts packet[:value]
end


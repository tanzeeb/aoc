#!/usr/bin/env ruby
# frozen_string_literal: true

def parse transmission
  version = transmission[0..2].to_i(2)
  type = transmission[3..5].to_i(2)
  literal = nil
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

    literal = bits.to_i(2)
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
  end

  return { version: version, type: type, literal: literal, packets: packets }, remainder
end

def sum_version packet
  return packet[:version] + packet[:packets].inject(0) {|sum,p| sum += sum_version p}
end

ARGF.readlines(chomp: true).map do |line|
  transmission = line.split("").map { |h| "%04b" % h.to_i(16) }.join("")

  packet, remainder = parse transmission

  puts sum_version packet
end


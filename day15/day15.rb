#!/usr/bin/env ruby

discs = DATA.readlines.map do |line|
  m = line.match(/has (\d+) positions.*at position (\d+)/)
  { positions: m[1].to_i, initial: m[2].to_i }
end

def position_at(disc, t)
  (disc[:initial] + t) % disc[:positions]
end

def drops_through?(discs, drop_time)
  discs.each_with_index.all? do |disc, index|
    position_at(disc, drop_time + 1 + index).zero?
  end
end

Infinity = 1.0 / 0.0

t1 = (0..Infinity).find { |drop_time| drops_through?(discs, drop_time) }
puts "part one: #{t1}"

discs << { positions: 11, initial: 0 }
t2 = (t1..Infinity).find { |drop_time| drops_through?(discs, drop_time) }
puts "part two: #{t2}"

__END__
Disc #1 has 5 positions; at time=0, it is at position 2.
Disc #2 has 13 positions; at time=0, it is at position 7.
Disc #3 has 17 positions; at time=0, it is at position 10.
Disc #4 has 3 positions; at time=0, it is at position 2.
Disc #5 has 19 positions; at time=0, it is at position 9.
Disc #6 has 7 positions; at time=0, it is at position 0.

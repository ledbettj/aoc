#!/usr/bin/env ruby

ELF_COUNT = 3_014_387
#ELF_COUNT = 5

Elf = Struct.new(:id, :presents, :neighbor)

# set up our linked list
head = nil
tail = nil

ELF_COUNT.times do |i|
  e = Elf.new(i + 1, 1, nil)
  head ||= e

  tail&.neighbor = e
  tail = e
end

tail.neighbor = head

ptr = head

until ptr.neighbor == ptr
  neighbor = ptr.neighbor
  ptr.presents += neighbor.presents
  ptr.neighbor = neighbor.neighbor

  ptr = ptr.neighbor
end

puts ptr.inspect

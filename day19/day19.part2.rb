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

before_across = head
(ELF_COUNT / 2 - 1).times { before_across = before_across.neighbor }
across = before_across.neighbor

remaining = ELF_COUNT

until ptr == ptr.neighbor
  #  puts "#{ptr.id} across is #{across.id}"
  ptr.presents += across.presents

  before_across.neighbor = across.neighbor
  before_across = across.neighbor if remaining.odd?

  across = before_across.neighbor

  ptr = ptr.neighbor
  remaining -= 1
end

puts ptr.inspect

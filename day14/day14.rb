#!/usr/bin/env ruby
require 'digest/md5'

MAGIC = 'ihaygndm'.freeze

found = []

index = 0

hashes = Hash.new do |h, k|
  # Part1
  # h[k] = Digest::MD5.hexdigest("#{MAGIC}#{k}")
  # Part 2
  hash = Digest::MD5.hexdigest("#{MAGIC}#{k}")
  2016.times { hash = Digest::MD5.hexdigest(hash) }
  h[k] = hash
end

def threepeat_char(hash)
  m = hash.match(/(.)(\1){2}/)
  m ? m[1] : nil
end

until found.length == 64
  h = hashes[index]
  if (char = threepeat_char(h))
    fivepeat = char * 5
    if (1..1000).any? { |off| hashes[index + off].index(fivepeat) }
      found << [h, index]
      puts "found #{h} at index #{index} (# #{found.length})"
    end
  end
  hashes.delete(index)
  index += 1
end

#puts found.inspect

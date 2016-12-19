#!/usr/bin/env ruby
require 'digest/md5'

class Vault
  attr_reader   :width, :height
  attr_accessor :start, :secret

  def initialize(width, height, secret = 'hijkl', start = [0, 0])
    @width  = width
    @height = height
    @start  = start
    @secret = secret
  end

  def shortest_path_to(dest = [3, 3])
    paths = []
    path  = []
    until pos_from_path(start, path) == dest
      new_paths = available_directions(path).map do |m|
        new_path = path.dup
        new_path << m
      end

      paths += new_paths
      paths.sort_by!(&:length)
      path = paths.shift
    end

    path.join('')
  end

  def longest_path_to(dest = [3, 3])
    paths = []
    path  = []
    solution = nil

    loop do
      pos = pos_from_path(start, path)
      print "at #{pos.inspect} after #{path.length} moves. #{paths.length} paths left: "
      if pos == dest
        puts "solution in #{path.length}"
        solution ||= path.length
        solution = [solution, path.length].max
      else
        new_paths = available_directions(path).map do |m|
          print "#{m}"
          new_path = path.dup
          new_path << m
        end

        puts('')

        paths += new_paths
      end
      path = paths.shift

      break if path.nil?
    end

    solution
  end

  private

  def available_directions(path)
    pos   = pos_from_path(start, path)
    moves = %w(U D L R)
    hash = Digest::MD5.hexdigest(secret + path.join(''))
    x = moves.each_with_index
      .select { |_, i| hash[i] =~ /[b-f]/ }
      .map(&:first)
      .select { |move| valid_location?(pos_from_path(pos, [move])) }
    #puts "at #{pos.inspect} can move #{x}"
    x
  end

  def valid_location?(pos)
    pos[0] >= 0 && pos[0] < width && pos[1] >= 0 && pos[1] < height
  end

  def pos_from_path(initial, path)
    path.reduce(initial.dup) do |(x, y), move|
      case move
      when 'U' then [x, y - 1]
      when 'D' then [x, y + 1]
      when 'L' then [x - 1, y]
      when 'R' then [x + 1, y]
      else raise ArgumentError
      end
    end
  end
end

tests= [
#  [Vault.new(4, 4, 'ihgpwlah'), 'DDRRRD', 370],
#  [Vault.new(4, 4, 'kglvqrro'), 'DDUDRLRRUDRD', 492],
#  [Vault.new(4, 4, 'ulqzkmiv'), 'DRURDRUDDLLDLUURRDULRLDUUDDDRR', 830]
]

tests.each do |v, short, long|
  puts v.longest_path_to
  puts [v.secret, v.shortest_path_to == short, v.longest_path_to == long].inspect
end

puts Vault.new(4, 4, 'qljzarfv').shortest_path_to
puts Vault.new(4, 4, 'qljzarfv').longest_path_to

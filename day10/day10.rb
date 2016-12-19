#!/usr/bin/env ruby

INSTRUCTIONS = File.readlines('instructions.txt').map(&:chomp)

class Bot
  attr_accessor :low_target, :high_target, :values
  attr_reader :id
  def initialize(id)
    @id = id
    @values = []
  end

  def assign(value)
    values.push(value)
  end

  def low_value
    values.min
  end

  def high_value
    values.max
  end

  def empty!
    self.values = []
  end

  def one?
    values.length == 1
  end

  def full?
    values.length == 2
  end
end

class Factory
  attr_reader :instructions
  attr_accessor :bots, :outputs

  GIVE_REGEX = /bot (?<give_id>\d+) gives low to (?<low_target_type>[^\s]+) (?<low_target_id>\d+) and high to (?<high_target_type>[^\s]+) (?<high_target_id>\d+)/
  VALUE_REGEX = /value (?<value>\d+) goes to (?<dest_type>[^\s]+) (?<dest_id>\d+)/

  def initialize(instructions)
    @instructions = instructions
    @bots    = []
    @outputs = []
    prepare
  end

  def execute
    bots.each do |bot|
      next unless bot.full?
      lo_t = lookup(*bot.low_target)
      hi_t = lookup(*bot.high_target)

      lo_t.assign(bot.low_value)
      hi_t.assign(bot.high_value)

      # part one
      # if bot.values.sort == [17, 61]
      #  puts bot.id
      #  raise 'done fuckers'
      # end

      # part 2
      if outputs.first(3).all?(&:one?)
        puts outputs.first(3).map { |o| o.values.first }.reduce(&:*)
        raise 'done fuckers'
      end

      bot.empty!
    end

    execute
  end

  private

  def lookup(type, id)
    bucket = send("#{type}s")
    bucket[id] ||= Bot.new("#{type}-#{id}")
    bucket[id]
  end

  def assign(type, id, value)
    lookup(type, id).assign(value)
  end

  def give(from_id, low_target, high_target)
    giver = lookup('bot', from_id)
    giver.low_target = low_target
    giver.high_target = high_target

    lookup(*low_target)
    lookup(*high_target)
  end

  def prepare
    instructions.each do |i|
      case
      when (m = i.match(GIVE_REGEX))
        give(m[:give_id].to_i,
             [m[:low_target_type], m[:low_target_id].to_i],
             [m[:high_target_type], m[:high_target_id].to_i])
      when (m = i.match(VALUE_REGEX))
        assign(m[:dest_type], m[:dest_id].to_i, m[:value].to_i)
      else
        raise "shit"
      end
    end
  end
end

f = Factory.new(INSTRUCTIONS)
f.execute

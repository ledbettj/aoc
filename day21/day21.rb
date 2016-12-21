#!/usr/bin/env ruby

TEST_RULES = <<EOF
swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d
EOF

def assert_eq(desc, a, b)
  puts "#{desc}> #{a} == #{b}: #{(a == b ? 'pass' : 'fail!')}"
end

class Scrambler
  attr_reader :rules
  def initialize(rules)
    @rules = parse_rules(rules)
  end

  def scramble(password)
    rules.reduce(password) do |str, (instr, args)|
      send(instr, str, *args)
    end
  end

  def unscramble(scrambled)
    rules.reverse.reduce(scrambled) do |str, (instr, args)|
      send("#{instr}_undo", str, *args)
    end
  end

  private

  def swap_pos(input, from, to)
    from = from.to_i
    to   = to.to_i
    c = input[from]
    input[from] = input[to]
    input[to] = c

    input
  end
  alias swap_pos_undo swap_pos

  def swap_let(input, c1, c2)
    input.gsub(/[#{c1}#{c2}]/) do |ch|
      ch == c1 ? c2 : c1
    end
  end
  alias swap_let_undo swap_let

  def rev_pos(input, from, to)
    from = from.to_i
    to   = to.to_i
    [
      input[0...from],
      input[from..to].reverse,
      input[(to + 1)..-1]
    ].join('')
  end
  alias rev_pos_undo rev_pos

  def rotate(input, direction, count)
    count = count.to_i
    count = -count if direction == 'right'
    input.chars.rotate(count).join('')
  end

  def rotate_undo(input, direction, count)
    rotate(input, direction == 'right' ? 'left' : 'right', count)
  end

  def rot_let(input, letter)
    index = input.index(letter)
    count = index + (index >= 4 ? 1 : 0) + 1
    rotate(input, 'right', count)
  end

  def rot_let_undo(input, letter)
    s = input
    s = rotate(s, 'left', 1) until rot_let(s, letter) == input
    s
  end

  def move_pos(input, from, to)
    from = from.to_i
    to   = to.to_i
    ch   = input[from]
    s = "#{input[0...from]}#{input[(from + 1)..-1]}"

    "#{s[0...to]}#{ch}#{s[to..-1]}"
  end

  def move_pos_undo(input, from, to)
    move_pos(input, to, from)
  end

  RULES = {
    swap_pos: /swap position (\d+) with position (\d+)/,
    swap_let: /swap letter (.) with letter (.)/,
    rev_pos:  /reverse positions (\d+) through (\d+)/,
    rotate:   /rotate (left|right) (\d+) step/,
    rot_let:  /rotate based on position of letter (.)/,
    move_pos: /move position (\d+) to position (\d)/
  }

  def parse_rules(text)
    text.lines.map { |line| parse_rule(line) or raise ArgumentError }
  end

  def parse_rule(line)
    RULES.map { |name, regex| [name, line.match(regex)&.captures] }.find { |pair| pair.last }
  end
end

s = Scrambler.new(TEST_RULES)
assert_eq "test case", s.scramble('abcde'), 'decab'

# s = Scrambler.new("swap position 0 with position 3")
# assert_eq "swap pos", s.scramble('zest'), 'tesz'

# s = Scrambler.new("swap letter z with letter t")
# assert_eq "swap letter", s.scramble('zzatt'), 'ttazz'

# s = Scrambler.new("reverse positions 2 through 4")
# assert_eq "reverse pos", s.scramble('abzyxc'), 'abxyzc'

# s = Scrambler.new("rotate left 2 steps")
# assert_eq "rot left", s.scramble("abcdef"), "cdefab"

# s = Scrambler.new("rotate right 2 steps")
# assert_eq "rot right", s.scramble("abcdef"), "efabcd"

# s = Scrambler.new("move position 1 to position 4")
# assert_eq "mov pos", s.scramble("xayzb"), "xyzba"

s = Scrambler.new(DATA)

puts s.scramble("abcdefgh")
puts s.unscramble("fbgdceah")

__END__
rotate right 3 steps
swap letter b with letter a
move position 3 to position 4
swap position 0 with position 7
swap letter f with letter h
rotate based on position of letter f
rotate based on position of letter b
swap position 3 with position 0
swap position 6 with position 1
move position 4 to position 0
rotate based on position of letter d
swap letter d with letter h
reverse positions 5 through 6
rotate based on position of letter h
reverse positions 4 through 5
move position 3 to position 6
rotate based on position of letter e
rotate based on position of letter c
rotate right 2 steps
reverse positions 5 through 6
rotate right 3 steps
rotate based on position of letter b
rotate right 5 steps
swap position 5 with position 6
move position 6 to position 4
rotate left 0 steps
swap position 3 with position 5
move position 4 to position 7
reverse positions 0 through 7
rotate left 4 steps
rotate based on position of letter d
rotate left 3 steps
swap position 0 with position 7
rotate based on position of letter e
swap letter e with letter a
rotate based on position of letter c
swap position 3 with position 2
rotate based on position of letter d
reverse positions 2 through 4
rotate based on position of letter g
move position 3 to position 0
move position 3 to position 5
swap letter b with letter d
reverse positions 1 through 5
reverse positions 0 through 1
rotate based on position of letter a
reverse positions 2 through 5
swap position 1 with position 6
swap letter f with letter e
swap position 5 with position 1
rotate based on position of letter a
move position 1 to position 6
swap letter e with letter d
reverse positions 4 through 7
swap position 7 with position 5
swap letter c with letter g
swap letter e with letter g
rotate left 4 steps
swap letter c with letter a
rotate left 0 steps
swap position 0 with position 1
reverse positions 1 through 4
rotate based on position of letter d
swap position 4 with position 2
rotate right 0 steps
swap position 1 with position 0
swap letter c with letter a
swap position 7 with position 3
swap letter a with letter f
reverse positions 3 through 7
rotate right 1 step
swap letter h with letter c
move position 1 to position 3
swap position 4 with position 2
rotate based on position of letter b
reverse positions 5 through 6
move position 5 to position 3
swap letter b with letter g
rotate right 6 steps
reverse positions 6 through 7
swap position 2 with position 5
rotate based on position of letter e
swap position 1 with position 7
swap position 1 with position 5
reverse positions 2 through 7
reverse positions 5 through 7
rotate left 3 steps
rotate based on position of letter b
rotate left 3 steps
swap letter e with letter c
rotate based on position of letter a
swap letter f with letter a
swap position 0 with position 6
swap position 4 with position 7
reverse positions 0 through 5
reverse positions 3 through 5
swap letter d with letter e
move position 0 to position 7
move position 1 to position 3
reverse positions 4 through 7

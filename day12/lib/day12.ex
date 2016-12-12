defmodule Day12 do
  @instructions ~s"""
cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 19 c
cpy 11 d
inc a
dec d
jnz d -2
dec c
jnz c -5
"""

  def run do
    instructions = String.split(@instructions, "\n", trim: true)
    |> Enum.map(&Instruction.new(&1))
    |> List.to_tuple

    # Part 1
    Computer.new(instructions, %{a: 0, b: 0, c: 0, d: 0})
    |> Computer.run
    |> IO.inspect

    # Part 2
    Computer.new(instructions, %{a: 0, b: 0, c: 1, d: 0})
    |> Computer.run
    |> IO.inspect

  end
end

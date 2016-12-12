defmodule InstructionTest do
  use ExUnit.Case

  test "constructor" do
    assert Instruction.new("inc a") == {:inc, {:register, :a}}
    assert Instruction.new("dec b") == {:dec, {:register, :b}}
    assert Instruction.new("cpy b a") == {:cpy, {{:register, :b}, {:register, :a}}}
    assert Instruction.new("cpy 12 a") == {:cpy, {{:value, 12}, {:register, :a}}}
    assert Instruction.new("jnz 12 3") == {:jnz, {{:value, 12}, {:value, 3}}}
    assert Instruction.new("jnz b -3") == {:jnz, {{:register, :b}, {:value, -3}}}
  end
end

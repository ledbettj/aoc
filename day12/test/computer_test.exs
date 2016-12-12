defmodule ComputerTest do
  use ExUnit.Case

  test "inc/dec" do
    pgm = {
      Instruction.new("inc a"),
      Instruction.new("inc a"),
      Instruction.new("dec b")
    }
    c = Computer.new(pgm, %{a: 0, b: 0})
    assert Computer.register(c, :a) == 0
    c = Computer.step(c)
    assert Computer.register(c, :a) == 1
    c = Computer.step(c)
    assert Computer.register(c, :a) == 2
    c = Computer.step(c)
    assert Computer.register(c, :b) == -1
    assert Computer.halted?(c)

    c = Computer.new(pgm, %{a: 0, b: 0})
    %{state: state} =  Computer.run(c)
    assert state == %{a: 2, b: -1, ip: 3}
  end

  test "cp" do
        pgm = {
      Instruction.new("cpy 10, a"),
      Instruction.new("cpy a, b")
    }
    c = Computer.new(pgm, %{a: 0, b: 0}) |> Computer.run
    assert c[:state] == %{a: 10, b: 10, ip: 2}
  end
end

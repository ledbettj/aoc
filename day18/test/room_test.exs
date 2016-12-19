defmodule RoomTest do
  use ExUnit.Case

  test "new" do
    assert Room.new(".^.") == [:safe, :trap, :safe]
  end

  test "to_string" do
    assert Room.to_string([:safe, :trap]) == ".^"
  end

  test "next" do
    rc = Room.new("..^^.")
    |> Room.next
    |> Room.to_string

    assert rc == ".^^^^"
  end

  test "example case" do
    r = Room.new(".^^.^.^^^^")
    lines = Enum.reduce(1..9, [r], fn(_, acc) ->
      prev = hd(acc)
      [ Room.next(prev) | acc]
    end)
    |> Enum.reverse
    |> Enum.map(&Room.to_string(&1))
    |> Enum.join("\n")

    expected = ~s"""
.^^.^.^^^^
^^^...^..^
^.^^.^.^^.
..^^...^^^
.^^^^.^^.^
^^..^.^^..
^^^^..^^^.
^..^^^^.^^
.^^^..^.^^
^^.^^^..^^
"""

    assert lines == String.trim(expected)
  end

  test "counting" do
    r = Room.new(".^^.^.^^^^")
    {c, _} = Enum.reduce(1..9, {3, r}, fn(_, {sum, current}) ->
      current = Room.next(current)
      sum = sum + Enum.count(current, &(&1 == :safe))
      {sum, current}
    end)

    assert c == 38
  end

end

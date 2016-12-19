defmodule Day18 do

  def part1 do
    r = Room.new("......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^..")

    safe_count = fn (room) -> Enum.count(room, &(&1 == :safe)) end
    total = safe_count.(r)

    # part 1: 40
    # part 2: 400000
    {sum, _} = Enum.reduce(1..399999, {total, r}, fn (_, {sum, current}) ->
      current = Room.next(current)
      {sum + safe_count.(current), current}
    end)

    IO.puts("#{sum} safe tiles")
  end
end

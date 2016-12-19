defmodule Room do
  def new(str) do
    String.codepoints(str)
    |> Enum.map(fn "." -> :safe ; "^" -> :trap end)
  end

  def next(room) do
    arity = length(room)
    Stream.with_index(room)
    |> Enum.map(fn {center, index} ->
      left  = if (index == 0) || Enum.at(room, index - 1) == :safe, do: :safe, else: :trap
      right = if (index == arity - 1) || Enum.at(room, index + 1) == :safe, do: :safe, else: :trap

      next_spot({left, center, right})
    end)
  end

  def to_string(room) do
    Enum.map(room, fn :safe -> "." ; :trap -> "^" end)
    |> Enum.join("")
  end

  defp next_spot({:trap, :trap, :safe}), do: :trap
  defp next_spot({:safe, :trap, :trap}), do: :trap
  defp next_spot({:trap, :safe, :safe}), do: :trap
  defp next_spot({:safe, :safe, :trap}), do: :trap
  defp next_spot(_), do: :safe
end

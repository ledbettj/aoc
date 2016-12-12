defmodule Instruction do
  @moduledoc """
  Represents an instruction inside the toy computer.

  Handles parsing the given text-based instructions into
  A more machine friendly tuple set.
  """

  def new("inc " <> register) do
    {:inc, {:register, String.to_atom(register)}}
  end

  def new("dec " <> register) do
    {:dec, {:register, String.to_atom(register)}}
  end

  def new("jnz " <> rest) do
    {:jnz, parse_pair(rest)}
  end

  def new("cpy " <> rest) do
    {:cpy, parse_pair(rest)}
  end

  defp parse_pair(str) do
    String.split(str, ~r/\s+/)
    |> Enum.map(fn(word) ->
      if Regex.match?(~r/^\-?\d+$/, word) do
        {v , _} = Integer.parse(word)
        {:value, v}
      else
        {:register, String.to_atom(word)}
      end
    end
    )
    |> List.to_tuple
  end
end


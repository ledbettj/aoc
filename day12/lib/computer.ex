defmodule Computer do
  @doc """
  Create a new toy computer.

  `instructions` should be a tuple of Instruction objects.
  `state` should be a map of the initial register state.
  """
  def new(instructions, state) do
    %{instructions: instructions, state: Map.merge(state, %{ip: 0})}
  end

  @doc "Execute a single instruction and return the new computer/state."
  def step(%{instructions: instructions, state: state}) do
    ip    = state[:ip]
    instr = elem(instructions, ip)
    state = case instr do
              {:inc, {:register, r}} ->
                Map.merge(state, %{ :ip => ip + 1, r => state[r] + 1})
              {:dec, {:register, r}} ->
                Map.merge(state, %{ :ip => ip + 1, r => state[r] - 1})
              {:cpy, {{:register, s}, {:register, d}}} ->
                Map.merge(state, %{:ip => ip + 1, d => state[s]})
              {:cpy, {{:value, v}, {:register, d}}} ->
                Map.merge(state, %{:ip => ip + 1, d => v})
              {:jnz, {{:value, v}, {:value, offset}}} ->
                ip = if v != 0, do: ip + offset, else: ip + 1
                Map.merge(state, %{ip: ip})
              {:jnz, {{:register, r}, {:value, offset}}} ->
                ip = if state[r] != 0, do: ip + offset, else: ip + 1
                Map.merge(state, %{ip: ip})
            end

    %{instructions: instructions, state: state}
  end

  def register(%{instructions: _, state: state}, which) do
    state[which]
  end

  def run(computer) do
    if halted?(computer) do
      computer
    else
      step(computer) |> run
    end
  end

  def halted?(%{instructions: instructions, state: state}) do
    state[:ip] >= tuple_size(instructions)
  end
end

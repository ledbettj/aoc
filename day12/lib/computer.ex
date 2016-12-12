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
    instr = elem(instructions, state[:ip])
    %{instructions: instructions, state: execute(instr, state)}
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

  defp execute({:inc, {:register, r}}, state) do
    Map.merge(state, %{:ip => state[:ip] + 1, r => state[r] + 1})
  end

  defp execute({:dec, {:register, r}}, state) do
    Map.merge(state, %{:ip => state[:ip] + 1, r => state[r] - 1})
  end

  defp execute({:cpy, {{:register, s}, {:register, d}}}, state) do
    Map.merge(state, %{:ip => state[:ip] + 1, d => state[s]})
  end

  defp execute({:cpy, {{:value, v}, {:register, d}}}, state) do
    Map.merge(state, %{:ip => state[:ip] + 1, d => v})
  end

  defp execute({:jnz, {{:value, v}, {:value, offset}}}, state) do
    ip = state[:ip]
    ip = if v != 0, do: ip + offset, else: ip + 1
    Map.merge(state, %{ip: ip})
  end

  defp execute({:jnz, {{:register, r}, {:value, offset}}}, state) do
    ip = state[:ip]
    ip = if state[r] != 0, do: ip + offset, else: ip + 1
    Map.merge(state, %{ip: ip})
  end
end

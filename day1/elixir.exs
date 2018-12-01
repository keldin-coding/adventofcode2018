defmodule Frequencies do
  def sum_frequency(filename) do
    filename
    |> inputs()
    |> Enum.reduce(0, fn input, acc ->
      perform_operation(acc, input)
    end)
  end

  def find_duplicate(filename) do
    filename
    |> inputs()
    |> do_find_duplicate(0, MapSet.new([0]))
  end

  defp do_find_duplicate(operations, accumulator, seen) do
    [current | rest] = operations

    next = perform_operation(accumulator, current)

    if MapSet.member?(seen, next) do
      next
    else
      next_operations = [current | Enum.reverse(rest)] |> Enum.reverse()
      do_find_duplicate(next_operations, next, MapSet.put(seen, next))
    end
  end

  defp inputs(filename) do
    filename
    |> filedata()
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(fn i ->
      {String.first(i), String.slice(i, 1..-1) |> String.to_integer()}
    end)
  end

  defp filedata(filename) do
    {:ok, data} = File.read(filename)

    data
  end

  defp perform_operation(base, {"+", number}), do: base + number
  defp perform_operation(base, {"-", number}), do: base - number
end

IO.inspect(Frequencies.find_duplicate("./input"))

defmodule Boxes do
  def checksum(filename) do
    counts =
      filename
      |> inputs()
      |> matches()

    counts[:twos] * counts[:threes]
  end

  def find_prototype(filename) do
    filename
    |> inputs()
    |> do_find_prototype()
  end

  # Part 2
  defp do_find_prototype(inputs) do
    [desired | rest] = inputs

    case is_prototype?(desired, rest) do
      false -> do_find_prototype(rest)
      found -> common_characters(desired, found)
    end
  end

  defp is_prototype?(_desired, []), do: false
  defp is_prototype?(desired, rest) do
    [current | tail] = rest

    case difference_of_one?(desired, current, 2) do
      true -> current
      false -> is_prototype?(desired, tail)
    end
  end

  # Evaluates if there is a difference of more than one letter (or no letters)
  # for two given lists.
  defp difference_of_one?(_first, _second, 0), do: false
  defp difference_of_one?([], [], 1), do: true
  defp difference_of_one?([], [], 2), do: false
  defp difference_of_one?(first, second, difference_count) do
    [first_head | first_tail] = first
    [second_head | second_tail] = second

    if first_head == second_head do
      difference_of_one?(first_tail, second_tail, difference_count)
    else
      difference_of_one?(first_tail, second_tail, difference_count - 1)
    end
  end

  defp common_characters(desired, found) do
    Enum.with_index(desired)
    |> Enum.map_join(fn {letter, index} ->
      case Enum.at(found, index) == letter do
        true -> letter
        false -> ""
      end
    end)
  end

  # Part 1
  defp matches(input_lists) do
    input_lists
    |> Enum.reduce(%{twos: 0, threes: 0}, fn word, acc ->
      count_map = count_letters(word)

      acc
      |> Map.put(:twos, acc[:twos] + count_map[:twos])
      |> Map.put(:threes, acc[:threes] + count_map[:threes])
    end)
  end

  defp count_letters(word) do
    Enum.reduce(word, %{}, fn letter, acc ->
      acc
      |> Map.put(letter, Map.get(acc, letter, 0) + 1)
    end)
    |> Map.values()
    |> Enum.uniq()
    |> Enum.reduce(%{twos: 0, threes: 0}, fn count, acc ->
      case count do
        2 -> Map.put(acc, :twos, acc[:twos] + 1)
        3 -> Map.put(acc, :threes, acc[:threes] + 1)
        _ -> acc
      end
    end)
  end

  # Utils
  defp filedata(filename) do
    {:ok, data} = File.read(filename)

    data
  end

  defp inputs(filename) do
    filename
    |> filedata()
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(fn i -> String.graphemes(i) end)
  end
end

IO.inspect(Boxes.checksum("./input"))
IO.inspect(Boxes.find_prototype("./input"))

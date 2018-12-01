require 'set'

seen_frequencies = Set.new([0] )

inputs = Dir.chdir(File.join(Dir.home, 'projects', 'adventofcode2018', 'day1')) do
  File.readlines('./input').map do |val|
    [val[0], val[1..-1].to_i]
  end
end

def find_frequency(input, start, seen)
  result = input.reduce(start) do |final, (operator, number)|
    new_val = final.send(operator, number)

    return new_val unless seen.add?(new_val)
    new_val
  end

  find_frequency(input, result, seen)
end

puts find_frequency(inputs, 0, seen_frequencies)

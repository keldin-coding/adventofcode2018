require 'pry'

class Word
  attr_reader :word, :has_pair, :has_triplet

  alias_method :has_pair?, :has_pair
  alias_method :has_triplet?, :has_triplet

  def initialize(word)
    @word = word
    @has_pair, @has_triplet = count_letters
  end

  def similar_letters(other)
    (0...word.length).map do |i|
      other[i] == word[i] ? word[i] : ""
    end
  end

  def method_missing(name, *args, &block)
    if word.respond_to?(name)
      word.send(name, *args, &block)
    else
      super
    end
  end

  private

  def count_letters
    pairs = false
    triplets = false

    letters = Hash.new(0)

    0.upto(word.length) do |i|
      letters[word[i]] += 1
    end

    letter_counts = letters.values

    [
      letter_counts.any? { |c| c == 2 },
      letter_counts.any? { |c| c == 3 }
    ]
  end
end

# Part 1
words = Dir.chdir(File.join(Dir.home, 'projects', 'adventofcode2018', 'day2')) do
  File.readlines('./input').map do |input|
    Word.new(input.chomp)
  end
end

count_map = words.each_with_object({twos: 0, threes: 0}) do |word, obj|
  obj[:twos] += 1 if word.has_pair?
  obj[:threes] += 1 if word.has_triplet?
end

puts count_map[:twos] * count_map[:threes]

# Part 2

words.each_with_index do |word, index|
  words[(index + 1)...words.length].each do |next_word|
    similar_letters = word.similar_letters(next_word)

    if similar_letters.join.length == word.length - 1
      puts similar_letters.join
      break
    end
  end
end



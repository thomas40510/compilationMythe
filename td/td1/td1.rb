# frozen_string_literal: true

class DictRegex
  def initialize(file)
    @file = file
    # print current directory
    @data = read_data
  end

  def read_data
    File.open(@file, 'r') do |f|
      f.readlines.map(&:chomp)
    end
  end

  def nb_match(regex)
    @data.select { |word| word =~ regex }.size
  end

  def nb_match2(regex)
    @data.count { |line| line.match(regex) }
  end

  def matches(regex)
    @data.select { |word| word =~ regex }
  end
end


dict_file = 'td/td1/dictionary.txt'

r = DictRegex.new(dict_file)

regex1 = /\w*(ion)$/
puts "Number of words matching #{regex1.inspect} is #{r.nb_match(regex1)}"

regex2 = /at[^rti]/
puts "Number of words matching #{regex2.inspect} is #{r.nb_match(regex2)}"

n1 = IO.readlines(dict_file).count { |line| !line.match(regex2).nil? }
n2 = r.nb_match(regex2)

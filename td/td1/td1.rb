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
end


r = DictRegex.new('td/td1/dictionary.txt')

regex1 = /(ion)/
puts "Number of words matching #{regex1.inspect} is #{r.nb_match(regex1)}"

regex2 = /(at)[^tri]/
puts "Number of words matching #{regex2.inspect} is #{r.nb_match(regex2)}"


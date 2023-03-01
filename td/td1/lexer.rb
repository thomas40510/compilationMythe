# frozen_string_literal: true

class Lexem
  def initialize(tag = nil, value = nil, position = nil)
    @tag = tag
    @value = value
    @position = position
  end

  def to_s
    "#{@type}: #{@value}"
  end
end

class Lexer
  def initialize(lexems = nil, regexps = nil)
    @lexems = lexems unless lexems.nil?
    @vocab = regexps
  end

  def lex(string)
    string.each_line.with_index do |line, line_number|
      line_number += 1
      line.each_char do |char|
        curr_match = nil
        @vocab.each do |regexp, tag|
          match = char.match(regexp)
          if match
            data = match[0]
            if tag
              lexem = Lexem.new(tag, data, line_number)
              @lexems << lexem
            end

          end

        end
      end
    end

  end

end
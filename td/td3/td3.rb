# frozen_string_literal: true

require 'rubygems'
require 'prettyprint'


module Statement
  def initialize(left, op, right)
    @left = left
    @op = op
    @right = right
  end

  attr_reader :left, :op, :right

  def raw
    className = self.class.name
    className = className[0].downcase + className[1..-1]
    { className => { left: @left, op: @op, right: @right } }
  end

  def to_s
    "#{@left} #{@op} #{@right}"
  end
end


class IfStatement
  include Statement
  def initialize(condition, body, else_content = nil)
    @condition = condition
    @body = body
    @else_content = else_content
  end

  attr_reader :condition, :body, :else_content

  def to_s
    "if (#{@condition}) { #{@body} }" + (@else_content.nil? ? '' : " else { #{@else_content} }")
  end

  def raw
    if @else_content.nil?
      { self.class.name => {
        condition: (@condition.is_a?(Expr) ? @condition.raw : @condition),
        body: @body.raw
      } }
    else
      { self.class.name => {
        condition: (@condition.is_a?(Expr) ? @condition.raw : @condition),
        body: @body.raw,
        else: @else_content.raw
      } }
    end
  end
end

class ElseStatement
  include Statement

  def initialize(body)
    @body = body
  end

  def to_s
    "else { #{@body} }"
  end

  def raw
    { else: @body.raw }
  end
end

class WhileStatement
  include Statement

  def initialize(condition, body)
    @condition = condition
    @body = body
  end

  def to_s
    "while (#{@condition}) { #{@body} }"
  end

  def raw
    { while: { condition: (@condition.is_a?(Expr) ? @condition.raw : @condition), body: @body.raw } }
  end
end

class AssignStatement
  include Statement

  def initialize(var, op, value)
    @left = var
    @op = op
    @right = value
  end
end

class Expr
  include Statement
  def initialize(left, op, right)
    @left = left
    @op = op
    @right = right
  end
end

class AST
  def initialize
    @statements = []
  end

  def add_statement(statement)
    @statements << statement
  end

  def to_s
    @statements.map(&:to_s).join("\n")
  end

  def get_statements
    @statements
  end

  def statements_as_tree
    res = []
    @statements.each do |statement|
      res << { statement.class.name => statement.raw } unless statement.nil?
    end
    res
  end
end


code1 = 'if (a == b) { Y = X; }'
code2 = 'if (a > b) { Y = X; } else { Y = Z; }'
code3 = 'X = Y; while(true){ if(a == b){ x = y; } else { y = x; } }'

ast = AST.new
ast.add_statement(IfStatement.new(Expr.new('a', '==', 'b'), AssignStatement.new('Y', '=', 'X')))
ast.add_statement(IfStatement.new(Expr.new('a', '>', 'b'),
                                  AssignStatement.new('Y', '=', 'X'),
                                  ElseStatement.new(AssignStatement.new('Y', '=', 'Z'))))
ast.add_statement(AssignStatement.new('X', '=', 'Y'))
ast.add_statement(WhileStatement.new('true', IfStatement.new(Expr.new('a', '==', 'b'),
                                                             AssignStatement.new('x', '=', 'y'),
                                                             ElseStatement.new(AssignStatement.new('y', '=', 'x')))))

puts ast.statements_as_tree

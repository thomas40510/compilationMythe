# frozen_string_literal: true

require 'rubygems'
require 'prettyprint'


module Statement
  def initialize(left, op, right)
    @left = left
    @op = op
    @right = right
    super()
  end

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
  def initialize(condition, body, else_content = nil)
    @condition = condition
    @body = body
    @else_content = else_content
  end

  def condition
    @condition
  end

  def body
    @body
  end

  def to_s
    "if (#{@condition}) { #{@body} }" + (@else_content.nil? ? '' : " else { #{@else_content} }")
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
      # add as {statement: {condition: {left: 'a', right: 'b'}, body: {var: 'Y', value: 'X'}}}
      res << { statement: statement.condition.raw, body: statement.body.raw }
    end
    res
  end
end

code = 'if (a == b) { Y = X; }'

ast = AST.new
ast.add_statement(IfStatement.new(Expr.new('a', '==', 'b'), AssignStatement.new('Y', '=', 'X')))

puts ast.get_statements
puts ast.statements_as_tree

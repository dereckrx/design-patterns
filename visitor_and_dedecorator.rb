class Doubler

  def self.double_with_case(target)
    case target
      when Numeric  then target * 2 
      when String   then target.each_char.with_object("") {|c,str| str << "#{c}#{c}" }
      when Array    then target.map {|o| self.double_with_case(o) }
      else
        "Don't know how to double #{target.class} #{target.inspect}"
    end
  end
  
  def self.double_with_visitor(target)
    target.accept(DoublerVisitor.new)
  end
  
  def self.double_with_decorator(target)
    DoublerDecorator.decorate(target).double # Returns decorated object
  end
  
end

### Vistor Code
module Visitable
  def accept(visitor)
    visitor.visit(self)
  end
end

class Object # Monkey patch to all objects
  include Visitable
end

# Base class
class Visitor 
  def self.visitor_for(*klasses, &block)
    klasses.each do |klass|
      define_method(:"visit_#{klass.name}", block)
    end
  end
  
  def visit(thing)
    thing.class.ancestors.each do |ancestor|
      method_name = :"visit_#{ancestor.name}"
      next unless respond_to?(method_name)
      return send(method_name, thing)
    end
    raise "Can't handle #{thing.class}"
  end
end

class DoublerVisitor < Visitor
  # Call parent class method to create 'visit_numeric' method
  visitor_for(Numeric) do |num|
    num*2
  end
  visitor_for(String) do |str|
    "#{str}#{str}"
  end
  visitor_for(Array) do |a|
    a.map {|i| i.accept(self) }
  end
  visitor_for(Object) do |o|
    "Don't know how to double #{o.class}: #{o.inspect}."
  end
end

### Decorator code
require 'delegate'
module Decoration 

  
  def decorator_for(*klasses, &block)
    klasses.each do |klass|
      decorators[klass] = Module.new(&block)
    end
  end
  
  def decorators
    @decorators ||= {}
  end
  
  def decorate(target)
    obj = SimpleDelegator.new(target)
    
    target.class.ancestors.reverse.each do |a|
      if decorators[a]
        obj.extend(decorators[a]) # extend the store decorator module
      end
    end
    
    return obj # Obj now decorated with new functionality in a module
  end
  
end

class DoublerDecorator
  extend Decoration
  # Can put any number of methods or attributes in these mini modules
  # Different objects could have different modules, not just the double method
  decorator_for(Array) do
    def double
      self.map {|i| DoublerDecorator.decorate(i).double }
    end
  end
  
  decorator_for(String) do
    def double
      self.each_char.with_object("") {|c,str| str << "#{c}#{c}" }
    end
  end
  
  decorator_for(Numeric) do 
    def double
      self * 2
    end
  end
  
  decorator_for(Object) do
    def double
      "Don't know how to double #{self.class} #{self.inspect}"
    end
  end
end

#### Runnning code

p Doubler.double_with_case(12)
p Doubler.double_with_case("abc")
p Doubler.double_with_case([6, "b"])
p Doubler.double_with_case({:a => 1, :b => 2})

p Doubler.double_with_visitor(12)
p Doubler.double_with_visitor("abc")
p Doubler.double_with_visitor([6, "b"])
p Doubler.double_with_visitor({:a => 1, :b => 2})

p Doubler.double_with_decorator(12)
p Doubler.double_with_decorator("abc")
p Doubler.double_with_decorator([6, "b"])
p Doubler.double_with_decorator({:a => 1, :b => 2})
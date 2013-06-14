
#!/usr/bin/env ruby

# http://en.wikipedia.org/wiki/Visitor_pattern

# Using a Compsite pattern on CarElements with a vistior pattern for printing

require 'forwardable'

#### Alternative with a wrapper, similar to decorator method ???
class AcceptorWrapper # Decorator implementation
  extend Forwardable 
  def_delegators :@real_acceptor, :print, :do
  
  def initialize(real_acceptor)
    @real_acceptor = real_acceptor
  end
    
  def accept(visitor)
    visitor.visit(self)
  end
end

### Main way

module Visitable # implements accept method interface
  def accept(visitor)
    visitor.visit(self)
  end
end

module CarElement
  include Visitable
end

module CarComposite 
  include CarElement
  attr_reader :elements
  
  def initialize; @elements = []; end

  def accept(visitor)
    visitor.visit(self)
    @elements.each { |e| e.accept(visitor) }
  end
end

class Wheel
  include CarElement
  attr_reader :name
  def initialize(name); @name = name; end
end

class Engine
  include CarElement
end

class Body 
  include CarElement
end

class Car
  include CarComposite
  def initialize
    @elements = [
      Wheel.new("front left"), Wheel.new("front right"),
      Wheel.new("back left"), Wheel.new("back right"),
      Body.new, Engine.new
    ]
  end
end

module CarElementVisitor # abstract interface class
  def visit(car_element); end # other types: engine, body, car
end

# This is where all the printing logic goes, out of the CarElements
class CarElementPrintVisitor 
  include CarElementVisitor
  def visit(car_element)
    case car_element.class.name
    when Wheel.name
      puts "Visiting #{car_element.name} wheel"
    when Engine.name
      puts "Visiting engine"
    when Body.name
      puts "Visiting body"
    when Car.name
      puts "Visiting car"
    end
  end
end

# THis is where all the *special* (read not responsibility of the 
# Car Element) behavior goes, decoupled from the object
class CarElementDoVisitor
  include CarElementVisitor
  def visit(car_element)
    case car_element.class.name
    when Wheel.name
      puts "kicking my #{car_element.name} wheel"
    when Engine.name
      puts "Starting my engine"
    when Body.name
      puts "Moving my body"
    when Car.name
      puts "Starting my car"
    end
  end
end

car = Car.new
car.accept(CarElementPrintVisitor.new)
car.accept(CarElementDoVisitor.new)
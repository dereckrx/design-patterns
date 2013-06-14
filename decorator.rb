#!/usr/bin/env ruby

require 'forwardable'
require 'stringio'

# Component
class SimpleWriter
  
  def initialize(str)
    @strio = StringIO.new(str, 'w')
  end
  
  def write(line)
    @strio.write(line)
    @strio.write("\n")
  end
  
  def pos
    @strio.pos
  end
  
  def rewind
    @strio.rewind
  end
  
  def close
    @strio.close
  end
  
  def string
    @strio.string
  end
  
end

# Decorator Base class
class WriterDecorator < # Other decorators inherent from this class
  
  extend Forwardable
  
  def_delegators :@real_writer, :write, :rewind, :pos, :close, :string
  
  def initialize(real_writer)
    @real_writer = real_writer
  end
end

# Decorator Subclass: modifies behavior
class WriterBetterDecorator < WriterDecorator
  # Override any component (@real_writer) methods who's 
  # behavior needs to be modified
  def write(line)
    super("Better: #{line}")
  end
end

sw = SimpleWriter.new("")
sw.write("Simple World")
better = WriterBetterDecorator.new(SimpleWriter.new(""))
better.write("Better World")
puts sw.string
puts better.string

### Using dynamic alternatives with wrapping
w = SimpleWriter.new('out')

class << w
  alias old_write write

  # Decorate by adding time to line
  def write(line)
    old_write("#{Time.now}: #{line}") # Calls the original method definition!
  end
  
end  

  

#!/usr/bin/env ruby

class WorkoutBuilderTemplate
  
  def initialize
    @selections = []
  end
  
  # The Template method
  def build(elements)
    elements.each do |e|
      o = define(e)
      add(o)
    end
    finalize
    return @selections
  end
  
  # Abstract methods
  def define(element)
    raise 'Called abstract method'
  end
  
  # Hook methods: non abstract methods that can provide default behavior
  # * Or they can simply notify subclasses of where the algorithm is in the process
  
  # Hook with default
  def add(obj, element)
    @selections << obj
    # call backs to update duration and such
  end

  # Hook that notifies subclasses that it's done selecting exercises
  # * subclasses might sort or analize exercises at this point
  def finalize
  end
  
  
end


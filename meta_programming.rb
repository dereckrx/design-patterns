#!/usr/bin/env ruby

require 'active_support/inflector'

module Mover
  def move
    'moving...'
  end
end

def new_organism(mover)
  
  animal = Object.new
  
  if mover
    animal.extend(Mover)
  end
  
  animal
  
end

class CompositeBase
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def self.member_of(composite_name)
    attr_name = "parent_#{composite_name}"
    raise 'Method redefinition' if instance_methods.include?(attr_name)
    class_eval("attr_accessor :#{attr_name}")
  end
  
  def self.composite_of(composite_name)
    member_of composite_name
    composite_name = composite_name.to_s
    code = %Q{
      def sub_#{composite_name.pluralize}
        @sub_#{composite_name.pluralize} = [] unless @sub_#{composite_name.pluralize}
        @sub_#{composite_name.pluralize}
      end
      
      def add_sub_#{composite_name}(child)
        return if sub_#{composite_name.pluralize}.include?(childe)
        sub_#{composite_name.pluralize} << child
        child.parent_#{composite_name} = self
      end
      
      def delete_sub_#{composite_name}(child)
        return unless sub_#{composite_name.pluralize}.include?(child)
        sub_#{composite_name.pluralize}.delete(child)
        child.parent_#{composite_name} = nil 
      end
    }
    class_eval(code)
  end
  
  # Can you respond to to check what any given instance can do
  def member_of_composite?(object, composite_name)
    object.respond_to?("parent_#{composite_name}")
  end
  
end

# This will add composite methods at runtime
class Jungle < CompositeBase
  composite_of :population
  
end
    
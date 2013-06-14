=begin 
 g = Group.new
 g.print
## in Group
  def print
    self.accept(GroupPrintVisitor.new)
  end
## OR 
  g.accept(GroupPrintVisitor.new)
=end

class Visitor
  
  # Dynamically adds visit methods to this class
  def self.visitor_for(klasses, &block)
    klasses.each do |klass|
      define_method(:"visit_#{klass.name}", block)
    end
  end
  
  def visit(visitable)
    visitable.class.ancestors.each do |ancestor|  
      method_name = :"visit_#{ancestor.name}"  
      next unless respond_to?(method_name)
      return send(method_name, thing)
    end
    raise "Can't handle #{visitable.class}"
  end
  
end
    
class PrintVisitor < Visitor 
  
  # visit_group_record(depth="1", print_built=true, file=nil)
  visitor_for GroupRecord do |g|
    d = self.data
    str = "#{depth} #{(d)? d.print_data : ''}"
    p str
    # Next line should be in a differet method? Or in Composite class?
    #my_groups.each_with_index { |group, index| group.print_groups(depth.gsub(/./," ") + "#{index+1}", print_built, file) } 
    return nil
  end
  
  # Method for all other objects
  visitor_for Object do |o|
    puts o.to_s
  end
end

# With Proxy
# $ ConversionProxy.new(Object.new)
class ConversionProxy
  
  def initialize(thing)
    @thing = thing
  end
  
  def print
    @thing.accept(PrintVisitor.new)
  end
end

# OR module?
module Visitiable
  def accept(visitor); visitor.visit(self); end
end

module Printable
  include Visitable
  def print
    accept(PrintVisitor.new)
  end
end

class GroupFilePrinterVisitor
  
  def visit(visitable, depth="1", print_built=true, file=nil)
    my_groups = print_built ? self.built_groups : self.groups
    d = (print_built && self.respond_to?(:data))? self.data : nil
    str = "#{depth} #{(d)? d.print_data : ''}"
    p str
    file.puts str if file
    my_groups.each_with_index { |group, index| group.print_groups(depth.gsub(/./," ") + "#{index+1}", print_built, file) } 
    return nil 
  end
  
end
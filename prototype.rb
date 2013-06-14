class Prototype
  
  attr_accessor :complex_attr 
  
  def clone
    super
  end
  
end

class PrototypeImpl < Prototype
  
  def initialize(complex_attr)
    self.complex_attr = complex_attr
  end
  
  def print_it
    puts self.complex_attr
  end
  
end

# Client code
prototype = PrototypeImpl.new("Complex")

10.times do |i|
  new_proto = prototype.clone();
  
  # Usage of values in prototype, imagine there's a lot of attrs to clone
  new_proto.complex_attr = new_proto.complex_attr + "#{i}"
  new_proto.print_it
  
end
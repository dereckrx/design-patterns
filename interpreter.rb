#!/usr/bin/env ruby

class Expression
  
  # def initialize(ids) # initializer for terminals
  # def initialize(experession) # initaializer for non terminals
  
  # def evaluate(string) # abstract method
  
  def o_or(other)
    Or.new(self, other)
  end
  
  def o_and(other)
    And.new(self, other)
  end
  
  def is_not(ids)
    IsNot.new(ids)
  end
  
  def all(*ids)
    All.new(*ids)
  end
  
  def has_facilities(f)
    HasFacilities.new(f)
  end
  
  def self.run
    Expression.new.run
  end
  
  def run
    all(1,2,3).o_and( all(3,4,5) ).evaluate
  end
  
end

class All < Expression
  
  def initialize(*ids)
    @ids = ids
  end
  
  def evaluate
    "id in (#{@ids.join(',')})"
  end

end

class IsNot < Expression
  
  def initialize(ids)
    @ids = ids
  end
  
  def evaluate
    "id not in (#{@ids})"
  end
  
end

class Or < Expression
  
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def evaluate
    "#{@expression1.evaluate} OR #{@expression2.evaluate}"
  end
  
end

class And < Expression
  
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def evaluate
    "#{@expression1.evaluate} AND #{@expression2.evaluate}"
  end

end

class HasFacilities < Expression
  
  def initialize(facilities)
    @facilities = facilities
  end
  
  def evaluate
    "facilities in #{@facilities}"
  end
  
end

# Usage: all(1,2,3) or 

# Add.new(Constant.new(2), Constant.new(2)).interpret => 2 + 2

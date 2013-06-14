
#### Using it for static, descriptively named constructors

# Blind man asks for a red ball. 
class WorkValue
  
  attr_accessor :value, :unit
  
  def from_seconds(seconds)
    self.new(seconds, :seconds)
  end
  
  def from_reps(reps)
    self.new(reps, :reps)
  end
     
  private 
  # Generally you make you initalizers private or protected
  # to force the client to use your factory methods
  def initialize(val, unit)
    self.val = val
    self.unit = unit
  end
end

# In this case, the factory method is placed inside a factory object
# Blind man has a ball, and asks somebody what color it is.
class WorkValueFactory
  
  def work_value_factory_method(work)
    case type_of(work)
    when :reps
      WorkValue.new(work, :reps)
    when :excel
      WorkValue.new(work, :seconds)
    end
  end
  
end

### OR rely on subclasses to overide the factory method
# Blind man paints a ball with whatever color he has. 

class SetDatum
  
  def initialize
    self.work = make_work
  end
  
  protected 
  def make_work; end; # Factory method: only subclasses can override
end

class RepSetDatum < SetDatum
  
  protected 
  def make_work
    WorkValue.new(10, :reps)
  end
end

class DurativeSetDatum < SetDatum
  
  protected 
  def make_work 
    WorkValue.new(30, :reps)
  end
end



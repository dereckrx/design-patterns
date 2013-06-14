#!/usr/bin/env ruby

# Product
class Protocol 
  attr_accessor :exercise, :sets, :reps, :rest
end

# abstract interface for builder
class ProtocolBuilder
  def protocol; return @protocol; end;
  def new_protocol; @protocol = Protocol.new; end;
  
  def exercise=(e); @exercise = e; end;
  def build_sets; end;
  def build_reps; end;
  def build_rest; end;
end

# Concrete builder
class WarmupProtocolBuilder < ProtocolBuilder

  def build_sets; @sets = 1; end;
  def build_reps; @reps = 30; end;
  def build_rest; @rest = 0; end;
end
# Concrete builder
class StrengthProtocolBuilder < ProtocolBuilder

  def build_sets; @sets = 3; end;
  def build_reps; @reps = 10; end;
  def build_rest; @rest = 60; end;
end

# Director
class Trainer
  
  def protocol_builder=(pb); @protocol_builder = pb; end;
  def protocol; @protocol_builder.protocol; end;
  def build_protocol
    @protocol_builder.new_protocol
    @protocol_builder.exercise = e
    @protocol_builder.build_sets
    @protocol_builder.build_reps
    @protocol_builder.build_rest
  end
end

# A trainer building a protocol for a client
class BuilderExample
  
  def train
    trainer = Trainer.new
    warmup_builder   = WarmupProtocolBuilder.new
    strength_builder = StrengthProtocolBuilder.new
    
    trainer.protocol_builder = warmup_builder
    trainer.build_protocol
    
    trainer.protocol_builder = strength_builder
    trainer.build_protocol
  end
  
end
#!/usr/bin/env ruby

require 'drb/drb'

class TestMethodMissing
  
  def hello
    puts("Hello from a real method")
  end
  
  def method_missing(name, *args)
    puts("Warning uknown method called: #{name}")
    puts("Arguments: #{args.join(' ')}")
  end
  
end

class ProtectionProxy
  
  def initialize(subject, owner)
    @subject = subject
    @owner = owner
  end
  
  def method_missing(name, *args)
    check_access
    s.send(name, * args)
  end
  
  def check_access 
    if "dereckrx" != @owner
      raise "Illegal access"
    end
  end
  
end

class VirtualProxy
  
  def initialize(&creation_block)
    @creation_block = creation_block
  end
  
  def method_missing(name, *args)
    s = subject
    s.send(name, *args)
  end
  
end

class RemoteProxy
  
  def initialize(url)
    @url = url
  end
  
  def method_missing(name, *args)
    @url.remote_procedure_call(name, *args) #???
  end
  
end

### Example of Remote Service
class MathService
  
  def add(a, b)
    a+b
  end
  
end

# Run in console or irb
## Tab 1: Server/service
require 'proxy_10'
require 'drb/drb'
math_service = MathService.new
DRb.start_service("druby://localhost:3030", math_service)
DRb.thread.join

## Tab 2: Client
# require 'drb/drb'
# DRb.start_service 
# math_service = DRbObject.new_with_uri("druby://localhost:3030")
## Then make request
# sum = math_service.add(2,2)



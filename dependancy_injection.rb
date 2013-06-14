# http://weblog.jamisbuck.org/2008/11/9/legos-play-doh-and-programming

class A
end

# method 1
# Factory method with default param. Bad for APIs because 
# now you must document the default param.
class B
  def new_client(with=A) 
    with.new 
  end
end

# Method 2 as 
# In tests, subclass B2 (or stub) to return the object you want
class B2
  def new_client
    client.new
  end

  def client # 
    A
  end
end

# Method 3
class B3
  def initialize(options={})
    @client_impl = options[:client] || A
  end

  def new_client
    @client_impl.new
  end
end
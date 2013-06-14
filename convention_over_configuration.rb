# Convention Statement:
# Name your adapter class ""<protocol>Adapter"" and put it in the adapter directory

class MessageGateway
  def initialize
    load_adapters
  end

  def process_message(message)
    adapter = adapter_for(message)
    adapter.send_message(message)
  end

  # Selects an adapter dynamically based on a naming convention
  # <scheme>Adapter ie: HttpAdapter, SmtpAdapter
  def adapter_for(message)
    protocol = message.to.scheme
    adapter_class = protocol.capitalize + 'Adapter'
    adapter_class = self.class.const_get(adapter_class)
    adapter_class.new
  end

  # To dynamically 'require' files in a dir
  def load_adapters
    lib_dir = File.dirname(__FILE__)
    full_pattern = File.join(lib_dir, 'adapter', '*.rb')
    Dir.glob(full_pattern).each {|file| require file }
  end
end

# IN file adabpter_scaffold.rb
# usage: $ ruby adapter_scaffold.rb ftp

protocol_name = ARGV[0]
class_name = protocol_name.capitalize + 'Adapter'
file_name = File.join('adapter', protocol_name + '.rb')

scaffolding = %Q{
  class #{class_name}
    def send_message(message)
      # Code to send the message
    end
  end 
}

File.open(file_name, 'w') do |f|
  f.write(scaffolding)
end

require "ostruct"
require "yaml"

class Settings
 cattr_accessor :source_file
 @@config ||= OpenStruct.new
 
 class << self
   def read_configuration
     raise LoadError unless File.exists?(source_file)
     @@config = OpenStruct.new(YAML.load_file(source_file))
     # get only the current environment's settings
     @@config = OpenStruct.new(@@config.__send__(Rails.env))
   end
   
   def method_missing(method_name, *args, &block)
     @@config.__send__(method_name, *args)
   end
 end
end
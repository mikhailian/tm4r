require 'rubygems'
require 'activerecord'

module ActiveRecord::Associations::ClassMethods
# == Fixes the module handling in ActiveRecord
# As an example, the following code would not work
# 
#   module FooBar
#     class Foo < ActiveRecord::Base
#       has_many (:bars) do
#         def [](name)
#           find(:all, :conditions => ["name = ?", name])
#         end
#       end
#     end
#
#     class Bar < ActiveRecord::Base
#     end
#   end
    def create_extension_modules(association_id, block_extension, extensions)
      extension_module_name = "#{self.to_s.demodulize}#{association_id.to_s.camelize}AssociationExtension"

      silence_warnings do
          Object.const_set(extension_module_name, Module.new(&block_extension))
        end
      Array(extensions).push(extension_module_name.constantize)
    end
end



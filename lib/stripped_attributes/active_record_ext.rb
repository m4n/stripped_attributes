module StrippedAttributes
  module ActiveRecordExt
    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end
    
    module ClassMethods
      def strip_attributes(*attrs)
        write_inheritable_attribute :stripped_attributes, attrs.empty? ? :all : attrs

        class_eval <<-EOV
          include InstanceMethods
          alias_method_chain :write_attribute, :stripping
          
          class << self
            def stripped_attributes
              read_inheritable_attribute :stripped_attributes
            end
        
            def strip_attribute?(attr)
              attrs = stripped_attributes
              attrs == :all || attrs.include?(attr.to_sym)
            end
          end
        EOV
      end
    end
    
    module InstanceMethods #:nodoc:
      private
        def write_attribute_with_stripping(attr, value) #:nodoc:
          if value.respond_to?(:strip) && self.class.strip_attribute?(attr)
            value = value.blank? ? nil : value.strip
          end
          
          write_attribute_without_stripping attr, value
        end
    end
  end
end


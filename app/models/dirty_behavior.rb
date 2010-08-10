#For new objects attr_changed? always return false
#  because write_attribute(with will_change! behavior) mixed to object after_initialize
#  

module DirtyBehavior
  extend ActiveSupport::Concern

  def self.included(base)
    base.class_eval do
      include ActiveModel::Dirty
    end
  end


  module InstanceMethods
    def after_initialize
      class_eval do
        include ReplaceMethod
      end
    end
  end

  module ReplaceMethod
    def write_attribute(prop, value)
      attr_name = prop.is_a?(CouchRest::Model::Property) ? prop.name : prop

      unless [:content_type].include?(attr_name.to_sym) 
        if respond_to?("#{attr_name}_will_change!")
          send("#{attr_name}_will_change!") 
        end
      end

      super(prop, value)
    end
  end
end

module ActionService
  module ORM

    # An exception to throw when unscrubbed input is provided
    class Unscrubbed < ArgumentError
      def initialize(msg=nil)
        @msg = msg || "Unscrubbed input provided"
      end
      
      def to_s
        @msg
      end
    end
    
    # Provide ORM tidyness
    module Guard
      def self.included(base)
        if base.ancestors.include?(::ActiveRecord::Base)
          base.send(:include, ActionService::ORM::ActiveRecord)
        else
          raise "Your ORM #{base.superclass} for #{base} is not supported (yet)"
        end
        
        base.extend Modes
      end
      
      module Modes
        def force_rinsed
          @force_rinsed = true
        end
        
        def force_rinsed?
          @force_rinsed == true ? true : false
        end
      end
    end

  end
end

require 'action_service/orm/active_record'

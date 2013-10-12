require 'cancan'
require 'active_support/core_ext'

require "action_service/version"
require "action_service/sandbox"
require "action_service/purpose"
require "action_service/event"
require "action_service/perimeter"
require "action_service/guards"
require "action_service/exceptions"

module ActionService
  class << self
    attr_accessor :warnings
    def sandbox(child)
      ActionService::Sandbox.new(child)
    end

    def warning(msg)
      return if @warnings == false
      return warning("Empty warning message") if msg.nil?

      warn("WARNING: #{msg}")
    end
  end
end


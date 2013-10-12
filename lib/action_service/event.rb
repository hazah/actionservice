require 'rufus-json/automatic'

module ActionService
  class Event
    attr_reader :name, :purpose, :payload

    def initialize(name, purpose, payload)
      @name    = name    || raise("An event must have a name")
      @purpose = purpose || raise("An event must have a purpose")
      @payload = payload
    end
  end
end

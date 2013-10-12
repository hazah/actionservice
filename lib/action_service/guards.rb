module ActionService
  # Hash with only allowed keys
  class ScrubbedHash < Hash; end

  # Hash with only allowed keys and untainted values
  class RinsedHash < Hash; end

  module Guards
    class << self
      attr_accessor :forbidden_keys
    end

    self.forbidden_keys = []
  end
end

require "action_service/guards/head_guard"
require "action_service/guards/strict_guard"
require "action_service/guards/easy_guard"

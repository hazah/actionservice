module ActionService
  # A very easy guard, lets everything happen unguarded. Perhaps not such
  # a good idea to be using this...
  #
  class EasyGuard < HeadGuard
    def initialize(child)
      super
      @unguarded = true
    end
  end
end
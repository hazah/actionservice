# ActionService

[![Build Status](https://secure.travis-ci.org/coffeeaddict/action_service.png)](http://travis-ci.org/coffeeaddict/action_service)

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/coffeeaddict/action_service)

A way to achieve modularity and modular security with a sandbox on steroids.

## Introduction

### Modules
A ActionService could be seen as collection of service objects, each
representing a 'play area' (think: doll area, lego table, etc. etc.).

Within the realm of action_service, the service objects are refered to as
modules.

### Sandboxing
The modules are plugged into the action_service and can be governed, both per
module and action_service wide. There are guards looking for, and preventing
trouble.

Each module is not just exposed as-is; it is sandboxed. Which means that they
must specify which methods are to be played with.

### Child
What good would a action_service with a sandbox full of toys be without a child?
In a Rails context; the most logical choise for a child would be
the ```current_user```.

## Installation

Add this line to your application's Gemfile:

    gem 'action_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_service

## Usage

```ruby
  # define a child
  child = User.find(2)

  # define a module (perimeter) for the child to play in
  class MyPlayModule < ActionService::Perimeter
    # every module must have a purpose.
    # The purpose also serves as a namespace
    #
    purpose :playing

    # use can-can rules to govern the perimeter
    govern do
      can :watch, Television
      cannot :watch, CableTV

      can :eat, Candy do |candy|
        child.quotum.allows(candy)
      end
    end

    # define exposed methods
    expose :watch_tv, :eat

    def watch_tv(tv)
      guard(:watch, tv)
      child.watch(tv)

      sleep(:four)
    end

    def eat(candy)
      guard(:eat, candy)
      child.eat(candy)
    end

    def sleep(len) # not_accessible_from_outside
      child.sleep(len)
    end

    # or expose methods in an 'annotation like way'

    expose :method
    # method that does nothing at all
    def method
    end
  end

  # load the child (any object) and the module into a sandbox
  sandbox = ActionService.sandbox(child)
  sandbox.load_module(MyPlayPerimeter)

  # you can now call the sandboxed methods on the sandbox
  sandbox.playing.watch_tv(CableTV.new)   # fails with ActionService::AccessDenied
  30.times do
    sandbox.playing.eat(Liquorice.new)    # fails after a while
  end

  sandbox.playing.sleep(:long)            # fails with NoMethodError

  sandbox.allows?(:watch, Television)
  # => true
```

You are not restricted to only one perimeter/module - that would be most
boring...

Infact, the above is the essence of things - but there is much much more fun
hidden inside the ActionService. More will follow on the Wiki

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

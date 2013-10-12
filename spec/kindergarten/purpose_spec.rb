require 'spec_helper'
require 'stringio'

describe ActionService::Purpose do
  before(:each) do
    @sandbox = ActionService.sandbox(:child)
  end

  it "should register the methods of a perimeter" do
    purpose = ActionService::Purpose.new(:test, @sandbox)

    expect {
      purpose.add_perimeter(SpecPerimeter, SpecPerimeter.instance(:child))
    }.to change {
      purpose.methods
    }
  end

  it "should warn on duplicate methods" do
    purpose = ActionService::Purpose.new(:test, @sandbox)
    purpose.add_perimeter(SpecPerimeter, SpecPerimeter.instance(:child))

    prev = $stderr.dup
    $stderr = StringIO.new
    ActionService.warnings = true

    expect {
      purpose.add_perimeter(SpecPerimeter, SpecPerimeter.instance(:child))
    }.to change {
      $stderr.length
    }

    $stderr = prev
    ActionService.warnings = false
  end

  it "should fail on restricted methods" do
    purpose = ActionService::Purpose.new(:test, @sandbox)
    expect {
      purpose.add_perimeter(IllegalModule, IllegalModule.instance(:child))
    }.to raise_error(ActionService::Perimeter::RestrictedMethodError)
  end

  it "should delegate method execution to the perimeter" do
    purpose   = ActionService::Purpose.new(:test, @sandbox)
    perimeter = SpecPerimeter.instance(:child, @sandbox.guard)
    purpose.add_perimeter(SpecPerimeter, perimeter)

    expect {
      purpose.evented
    }.to change {
      perimeter.evented?
    }
  end
end

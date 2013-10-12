require 'spec_helper'
require 'stringio'

describe ActionService do
  it "should have a version constant" do
    ActionService::VERSION.should_not be_nil
  end

  it "should have a sandbox method" do
    res = ActionService.sandbox("string")
    res.should be_kind_of(ActionService::Sandbox)
  end

  it "should have warnings" do
    ActionService.warnings = true
    prev = $stderr.dup
    $stderr = StringIO.new

    expect {
      ActionService.warning "see"
    }.to change {
      $stderr.length
    }

    $stderr = prev
    ActionService.warnings = false
  end
end

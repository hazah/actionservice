require 'spec_helper'

describe ActionService::HeadGuard do
  before(:each) do
    @guard = ActionService::HeadGuard.new("child")
  end

  it "should include CanCan ability" do
    @guard.should be_kind_of(CanCan::Ability)
  end

  describe :governing do
    it "should guard the child" do
      expect {
        @guard.guard(:free, "Willy")
      }.to raise_error(ActionService::AccessDenied)
    end

    it "should keep a closed eye" do
      expect {
        @guard.unguarded do
          @guard.guard(:free, "Willy")
        end
      }.to_not raise_error(ActionService::AccessDenied)
    end
  end

  describe :washing do
    it "should scrub attributes" do
      attr     = { :a => 1, :b => 2, :c => 3 }

      scrubbed = @guard.scrub(attr, :a, :c)
      scrubbed.should_not be_has_key(:b)
    end

    it "should return a ScrubbedHash after scrubbing" do
      attr     = { :a => 1, :b => 2, :c => 3 }

      scrubbed = @guard.scrub(attr, :a, :c)
      scrubbed.should be_kind_of(ActionService::ScrubbedHash)
    end

    it "should rinse attributes" do
      attr   = { :a => 1, :b => "2a", :c => 3 }
      rinsed = @guard.rinse(attr, :a => /(\d+)/, :b => /(\D+)/)

      rinsed.should_not be_has_key(:c)
      rinsed[:a].should eq "1"
      rinsed[:b].should eq "a"
    end

    it "should pass attributes" do
      attr   = { :a => "1", :b => "2a", :c => "3" }
      rinsed = @guard.rinse(attr, :a => :pass, :c => :pass)

      rinsed.should_not be_has_key(:b)
      rinsed[:a].should eq "1"
      rinsed[:c].should eq "3"
    end
    it "should return a RinsedHash after rinsing" do
      attr   = { :a => "1", :b => "2a", :c => "3" }
      rinsed = @guard.rinse(attr, :a => /(\d+)/, :b => /(\d+)/)

      rinsed.should be_kind_of(ActionService::RinsedHash)
    end
  end
end

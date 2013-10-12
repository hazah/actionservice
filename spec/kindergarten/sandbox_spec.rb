require 'spec_helper'

describe ActionService::Sandbox do
  it "should allow an instance for any child" do
    expect {
      ActionService::Sandbox.new(:any)
    }.to_not raise_error
  end

  it "should know it's child" do
    sandbox = ActionService::Sandbox.new(:its)
    sandbox.child.should eq :its
  end

  it "should create an empty guard for the object" do
    sandbox = ActionService::Sandbox.new(:object)
    sandbox.guard.should be_kind_of(ActionService::HeadGuard)
    sandbox.guard.should be_empty
  end

  it "should define an empty perimeter" do
    sandbox = ActionService::Sandbox.new(:child)
    sandbox.perimeters.should be_empty
  end

  it "should provide a extend_perimeter function" do
    sandbox = ActionService::Sandbox.new(:child)
    sandbox.should respond_to(:extend_perimeter)

    expect {
      sandbox.extend_perimeter(SpecPerimeter)
    }.to change {
      sandbox.perimeters.empty?
    }
  end

  describe :HeadGuard do
    before(:each) do
      @sandbox = ActionService::Sandbox.new(:child)
      @sandbox.extend_perimeter(SpecPerimeter, PuppetPerimeter)
    end

    it "should tell the outside what is allowed" do
      @sandbox.should be_allowed(:view, "string")
    end

    it "should know the rules accross perimeters" do
      puppet = @sandbox.puppets.grab
      @sandbox.should be_disallowed(:bbq, puppet)
    end

    it "should guard the entire sandbox" do
      expect {
        @sandbox.guard(:render, :nothing)
      }.to raise_error(ActionService::AccessDenied)
    end
  end

  describe :Loading do
    before(:each) do
      @sandbox = ActionService::Sandbox.new(:child)
    end

    it "should not load a module that has no sandboxed methods" do
      expect {
        @sandbox.load_module(MethodlessModule)
      }.to raise_error(ActionService::Perimeter::NoExposedMethods, /MethodlessModule does not expose any methods/)
    end

    it "should not load a module that has no purpose" do
      expect {
        @sandbox.load_module(PurposelessModule)
      }.to raise_error(ActionService::Perimeter::NoPurpose, /PurposelessModule does not have a purpose/)
    end

    it "should take on all subscriptions" do
      ActionService::Purpose.stubs(:_subscribe)

      @sandbox.load_module(PuppetPerimeter)
      purpose = @sandbox.purpose[:puppets]
      purpose.should_not be_nil

      # when we load the testing module, it subscribes to puppet play
      purpose.expects(:_subscribe)

      @sandbox.load_module(SpecPerimeter)
    end
  end

  describe :Purpose do
    before(:each) do
      @sandbox = ActionService::Sandbox.new(:kid)
    end

    it "should raise error for wrong purpose" do
      expect {
        @sandbox.empty.something
      }.to raise_error(ActionService::Sandbox::NoPurposeError)
    end

    it "should return a hash of purposes" do
      @sandbox.purpose.should be_kind_of(Hash)
    end
  end

  describe :Mediation do
    before(:all) do
      ActionService.warnings = true
    end
    after(:all) do
      ActionService.warnings = false
    end

    before(:each) do
      @sandbox = ActionService::Sandbox.new(:kid)
      @sandbox.load_module(PuppetPerimeter, DiningPerimeter, SpecPerimeter)
    end

    describe :subscribe do
      it "should subscribe the sandbox to events" do
        evented = false
        @sandbox.subscribe(:testing, :event) do
          evented = true
        end

        expect {
          @sandbox.testing.fire(:event)
        }.to change { evented }
      end

      it "should relay events between purposes" do
        expect {
          @sandbox.puppets.play(:dress, @sandbox.puppets.grab)
        }.to change {
          @sandbox.testing.puppet_dressed?
        }
      end
    end

    describe :unsubscribe do
      it "should unsubscribe the sandbox from events" do
        evented = 0
        @sandbox.subscribe(:testing, :event) do
          evented += 1
        end

        expect {
          @sandbox.testing.fire(:event)
        }.to change { evented }

        @sandbox.unsubscribe(:testing, :event)

        expect {
          @sandbox.testing.fire(:event)
        }.to_not change { evented }
     end
    end

    describe :Broadcast do
      it "should broadcast events" do
        evented = 0

        @sandbox.broadcast do |event|
          evented += 1
        end

        expect {
          @sandbox.testing.fire(:ce_ci_nest_pas_un_event)
        }.to change { evented }
      end
    end

  end
end

# encoding: utf-8
require "spec_helper"

describe :Ca do
  describe :Warning do

    context "sample warning" do
      before(:all) do
        @warning = Ca::Warning.new
      end

      it "could set forbidden tag flag and check it" do
        @warning.forbid.should be_true
        @warning.forbidden.should be_true
      end


      it "indicate false when no flag is set" do
        warning = Ca::Warning.new
        warning.any?.should be_false
      end

      it "indicate true when any flag is set" do
        warning = Ca::Warning.new
        warning.forbid
        warning.any?.should be_true
      end

    end

  end
end
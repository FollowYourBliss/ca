# encoding: utf-8
require "spec_helper"
describe :Ca do
  describe :Exceptions do
    describe :TagWarnings do
      context "Simple operations" do

        before(:each) do
          @example = Ca::Exceptions::TagWarnings.new([:polciono, :pio])
        end

        it "able to run initializer" do
          Ca::Exceptions::TagWarnings.new([:polciono, :pio]).should be_true
        end

        it "allow to fetch properties from Object" do
          @example.properties.include?(:pio).should be_true
        end

        it "klass method join properties field" do
          @example.klass.should match "polciono pio"
        end

      end
    end
  end
end
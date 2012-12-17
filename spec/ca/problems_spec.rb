# encoding: utf-8
require "spec_helper"
describe :Ca do
  describe :Description do
    context "reconize problems" do
      context "with h1" do
        context "if correct" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures[:h1_problem_ok])
            @object = Ca::Description.new text
          end

          it "don't create any h1 problem" do
            @object.problems.count.should equal 2
          end

        end

        context "if uncorrect" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures[:h1_problem_not_ok])
            @object = Ca::Description.new text
          end

          it "create problem" do
            @object.problems.first.should be_a Ca::H1Problem
          end

        end
      end

      context "with meta description while it" do
        context "doesn't exist, so" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures["medium_text"])
            @object = Ca::Description.new text
          end

          it "create problem" do
            @object.problems.first.should be_a Ca::MetaDescriptionProblem
          end
        end

        context "present, so" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures[:empty_description])
            @object = Ca::Description.new text
          end

          it "don't create problem" do
            @object.problems.count.should equal 2
          end
        end

        context "empty, so" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures[:fill_description])
            @object = Ca::Description.new text
          end

          it "create problem" do
            @object.problems.first.should be_a Ca::MetaDescriptionProblem
          end
        end
      end

      context "with meta keywords while it" do
        context "doesn't exist, so" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures["medium_text"])
            @object = Ca::Description.new text
          end

          it "create problem" do
            @object.problems.last.should be_a Ca::MetaKeywordsProblem
          end
        end

        context "empty, so" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures[:empty_keywords])
            @object = Ca::Description.new text
          end

          it "don't create problem" do
            @object.problems.count.should equal 2
          end
        end

        context "present, so" do
          before(:all) do
            text = Nokogiri::HTML(hard_fixtures[:fill_keywords])
            @object = Ca::Description.new text
          end

          it "create problem" do
            @object.problems.last.should be_a Ca::MetaKeywordsProblem
          end
        end
      end

    end
  end
end
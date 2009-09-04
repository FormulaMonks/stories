# encoding: utf-8

require 'test/unit/ui/console/testrunner'

module Stories
  def self.all
    @all ||= {}
  end

  module TestCase
    def self.included(base)
      class << base
        def story(name, *args, &block)
          context(name, *args) do
            Stories.all[self] = Stories::Story.new(name)
            class_eval(&block) if block_given?
          end
        end

        def scenario(name, *args, &block)
          scenario = Stories::Scenario.new(name)

          Stories.all[self].scenarios << scenario

          test(name) do
            @scenario = scenario
            instance_eval(&block)
          end
        end
      end
    end
  end
end

Test::Unit::TestCase.send(:include, Stories::TestCase)

module Test::Unit::Assertions
  def report(text, &block)
    @scenario.steps << text
    silent(&block) if block_given?
  end

  def silent(&block)
    scenario, @scenario = @scenario, Stories::Scenario.new("#{@scenario.name} (Silent)")

    begin
      block.call
    ensure
      @scenario = scenario
    end
  end
end

module Stories
  class Story
    attr_accessor :name, :scenarios

    def initialize(name)
      @name = name
      @scenarios = []
    end
  end

  class Scenario
    attr_accessor :name, :steps, :assertions

    def initialize(name)
      @name = name
      @steps = []
      @assertions = []
    end
  end

  class Runner < Test::Unit::UI::Console::TestRunner
    def test_finished(name)
      print "."
    end

    def add_fault(fault)
      print "F"
      @faults << fault
    end

    def finished(elapsed_time)
      puts

      Stories.all.values.to_a.each_with_index do |story,i|
        puts "- #{story.name}"

        story.scenarios.each do |scenario|
          puts "    #{scenario.name}"

          unless scenario.steps.empty? && scenario.assertions.empty?
            scenario.steps.each do |step|
              puts "      #{step}"
            end

            scenario.assertions.each do |assertion|
              puts "      #{assertion}"
            end

            puts
          end
        end

        puts unless i + 1 == Stories.all.values.size
      end

      super
      puts "%d stories, %d scenarios" % [Stories.all.values.size, Stories.all.values.inject(0) {|total,s| total + s.scenarios.size }]
    end
  end

  module Webrat
    def report_for(action, &block)
      define_method(action) do |*args|
        @scenario.steps << block.call(*args)
        super(*args)
      end
    end

    module_function :report_for
  end
end

Test::Unit::AutoRunner::RUNNERS[:stories] = proc do |r|
  Stories::Runner
end

Test::Unit::AutoRunner::RUNNERS[:"stories-pdf"] = proc do |r|
  begin
    Stories::Runner::PDF
  rescue NameError
    require File.expand_path(File.dirname(__FILE__) + "/runner/pdf")
    Stories::Runner::PDF
  end
end

# Common Webrat steps.
module Stories::Webrat
  report_for :click_link do |name|
    "Click #{quote(name)}"
  end

  report_for :click_button do |name|
    "Click #{quote(name)}"
  end

  report_for :fill_in do |name, opts|
    "Fill in #{quote(name)} with #{quote(opts[:with])}"
  end

  report_for :visit do |page|
    "Go to #{quote(page)}"
  end

  report_for :check do |name|
    "Check #{quote(name)}"
  end

  report_for :assert_contain do |text|
    "I should see #{quote(text)}"
  end

  def quote(text)
    "“#{text}”"
  end
  module_function :quote
end

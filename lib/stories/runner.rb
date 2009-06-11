require 'test/unit/ui/console/testrunner'

$stories = []

class Test::Unit::TestCase
  class << self
    alias original_story story
    alias original_scenario scenario

    def story(name, &block)
      story = Stories::Story.new(name)

      original_story(name) do
        @@story = story
        class_eval(&block)
      end

      $stories << story
    end

    def scenario(name, &block)
      scenario = Stories::Scenario.new(name)

      original_scenario(name) do
        @scenario = scenario
        instance_eval(&block)
      end

      @@story.scenarios << scenario
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

      $stories.each_with_index do |story,i|
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

        puts unless i + 1 == $stories.size
      end

      super
      puts "%d stories, %d scenarios" % [$stories.size, $stories.inject(0) {|total,s| total + s.scenarios.size }]
    end
  end

  module Webrat
    def report_for(action, &block)
      define_method(action) do |*args|
        @scenario.steps << block.call(*args)
        super
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

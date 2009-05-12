$stories = []

module ActiveSupport::Testing::Declarative
  def story(name, &block)
    story = StoryRunner::Story.new(name)

    super(name) do
      @@story = story
      yield
    end

    $stories << story
  end

  def scenario(name, &block)
    sarasa = StoryRunner::Scenario.new(name)

    super(name) do
      @steps = sarasa.steps
      instance_eval(&block)
    end
    
    @@story.scenarios << sarasa
  end
end

require 'test/unit/ui/console/testrunner'

class StoryRunner < Test::Unit::UI::Console::TestRunner
  def finished(elapsed_time)
    puts

    $stories.each do |story|
      puts "- #{story.name}"

      story.scenarios.each do |scenario|
        puts "    #{scenario.name}"

        unless scenario.steps.empty?
          scenario.steps.each do |step|
            puts "      #{step}"
          end

          puts
        end
      end

      puts
    end

    super
  end

  class Story
    attr_accessor :name, :scenarios

    def initialize(name)
      @name = name
      @scenarios = []
    end
  end

  class Scenario
    attr_accessor :name, :steps

    def initialize(name)
      @name = name
      @steps = []
    end
  end
end

module Webrat::Methods::Verbose
  def click_link(name)
    report "Click #{name.inspect}"
    super
  end
  
  def click_button(name)
    report "Click #{name.inspect}"
    super
  end
 
  def fill_in(name, opts = {})
    report "Fill in #{name.inspect} with #{opts[:with].inspect}"
    super
  end

  def visit(page)
    report "Go to #{page.inspect}"
    super
  end

  def assert_contain(text)
    report "I should see #{text.inspect}"
    super
  end

  private
    def report(action)
      @steps << action
    end
end

ActionController::IntegrationTest.send(:include, Webrat::Methods::Verbose)

Test::Unit::AutoRunner::RUNNERS[:story] = proc do |r|
  StoryRunner
end

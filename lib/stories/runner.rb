$stories = []

class Test::Unit::TestCase
  class << self
    alias original_story story
    alias original_scenario scenario

    def story(name, &block)
      story = StoryRunner::Story.new(name)

      original_story(name) do
        @@story = story
        yield
      end

      $stories << story
    end

    def scenario(name, &block)
      scenario = StoryRunner::Scenario.new(name)

      original_scenario(name) do
        @scenario = scenario
        instance_eval(&block)
      end
      
      @@story.scenarios << scenario
    end
  end
end

require 'test/unit/ui/console/testrunner'

class StoryRunner < Test::Unit::UI::Console::TestRunner
  def test_finished(name)
  end

  def add_fault(fault)
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
end

module Stories; end

module Stories::Webrat
  def click_link(name)
    @scenario.steps << "Click #{name.inspect}"
    super
  end
  
  def click_button(name)
    @scenario.steps << "Click #{name.inspect}"
    super
  end
 
  def fill_in(name, opts = {})
    @scenario.steps << "Fill in #{name.inspect} with #{opts[:with].inspect}"
    super
  end

  def visit(page)
    @scenario.steps << "Go to #{page.inspect}"
    super
  end

  def assert_contain(text)
    @scenario.steps << "I should see #{text.inspect}"
    super
  end

  def assert_equal(expected, actual, message = nil)
    @scenario.assertions << "#{actual.to_s.inspect} should be #{expected.to_s.inspect}."
    super
  end
end

Test::Unit::AutoRunner::RUNNERS[:story] = proc do |r|
  StoryRunner
end

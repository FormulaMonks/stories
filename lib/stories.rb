require "rubygems"
require "contest"

class Test::Unit::TestCase
  class << self
    alias scenario test

    def story(name, &block)
      $stories << name
      context(name, &block)
    end
  end
end

$stories = []

at_exit do
  unless $stories.empty?
    puts $stories.join("\n"); puts
  end
end

require "rubygems"
require "contest"

class Test::Unit::TestCase
  @@stories = []

  class << self
    alias scenario test

    def story(name, &block)
      @@stories << name
      context(name, &block)
    end

    def stories
      @@stories
    end
  end
end

at_exit do
  unless Test::Unit::TestCase.stories.empty?
    puts

    Test::Unit::TestCase.stories.each do |s|
      puts "- #{s}"
    end

    puts
  end
end

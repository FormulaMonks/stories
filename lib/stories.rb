require "rubygems"
require "contest"

class Test::Unit::TestCase
  class << self
    alias story context
    alias scenario test
  end
end

Test::Unit::AutoRunner::RUNNERS[:story] = proc do |r|
  puts "Story runner not found. You need to require 'stories/verbose'."
end

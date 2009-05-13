require File.dirname(__FILE__) + "/../lib/stories"
require File.dirname(__FILE__) + "/../lib/stories/runner"

# Use the story runner by default.
Test::Unit::AutoRunner::RUNNERS[:console] = Proc.new {|r| StoryRunner }

class UserStoryTest < Test::Unit::TestCase
  story "As a user I want to create stories so I can test if they pass" do
    setup do
      @user = "valid user"
    end

    scenario "A valid user" do
      assert_equal "valid user", @user
    end
  end
end

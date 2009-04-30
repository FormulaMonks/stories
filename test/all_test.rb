require File.dirname(__FILE__) + "/../lib/stories"

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

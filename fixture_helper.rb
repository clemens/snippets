# ------------------------
# Fixture Helper for RSpec
# ------------------------
#
# Sometimes you need fixture files – for instance, if you want to write tests for file uploads.
# I like to put my fixtures in a directory (`spec/fixtures`) and call a simple method to retrieve
# them.
#
# Usage:
#  - Create a file in your `spec/support` directory (e.g. `spec/support/fixture_helpers.rb`).
#  - Put all your fixture files in `spec/fixtures` (you can use subdirectories if you want to).
#  - Use the helper method in your code like so:
#    user = User.new(avatar: fixture('users/avatar.png').open)

module FixtureHelpers
  def fixture(filename)
    Rails.root.join("spec/fixtures/#{filename}")
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end

# If you're using FactoryGirl (you should!), use this to make the helper available in factory
# definitions. This enables you to do something like this:
#
#  factory :user do
#    avatar { fixture('users/avatar.png') }
#  end

FactoryGirl::SyntaxRunner.send(:include, FixtureHelpers)

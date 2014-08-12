# -------------------------------------------------------
# Shared "User is logged in" context for acceptance specs
# -------------------------------------------------------
#
# In lots of acceptance specs, there is a precondition that a user is logged in. I like to use a
# shared context for this because writing the same code over and over again is tedious and RSpec's
# shared contexts are just awesome (read more here: https://www.relishapp.com/rspec/rspec-core/docs/example-groups/shared-context).
#
# Usage:
#  - This uses code from my login helpers snippet. Make sure you either use this snippet as well or
#    provide your own `login_as` method.
#  - Put the code below in `spec/support/user_helpers.rb`.
#  - Use it in your acceptance specs on the top level or inside a context like so:
#    feature "Orders" do
#      include_context :user_is_logged_in # all scenarios in this feature use the shared context
#
#      context "when a user is logged in" do
#        include_context :user_is_logged_in # only scenarios in this context use the shared context
#      end
#    end
#
# Note: The code uses a FactoryGirl trait `:confirmed`. The factory looks something like this:
#
#  factory :user do
#    trait :confirmed do
#      # skip_confirmation! is how Devise allows you to manually set a user to confirmed.
#      after(:build) { |user| user.skip_confirmation! }
#    end
#  end
#
# Read more about traits here: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#traits
# If you're not using FactoryGirl (you should!), provide your own appropriate way to create a user
# that has the necessary data to be able to log in.

shared_context :user_is_logged_in do
  let!(:user) { create(:user, :confirmed) }

  background { login_as(user) }
end

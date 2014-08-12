# ----------------------------------
# Login Helpers for Acceptance Specs
# ----------------------------------
#
# Instead of repeating it over and over again, I've extracted this little method so I can use it
# whenever I need to log in a certain user.
#
# Usage:
#  - Put the code below in `spec/support/login_helpers.rb`.
#  - Whenever you need to log in a user, use the `login_as` method. Note that the user you want to
#    log in must exist and be passed in as a parameter.
#  - To log out, you can use the `logout` method.
#  - If you're using Devise, you can speed up your specs if you don't need to log in using your
#    app's regular mechanism all the time. You can just use Warden's test helper methods for it
#    (see https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara). I've wrapped
#    this in a separate `quick_login_as` method (including the corresponding `quick_logout` method).

include Warden::Test::Helpers
Warden.test_mode!

module LoginHelpers
  def quick_login_as(user, scope = :user)
    login_as(user, scope: scope)
  end

  def quick_logout(scope = :user)
    logout(scope: scope)
  end

  def login_as(user)
    visit new_session_path(user)

    # Note: I always use the same default password for all test users.
    within('#user-login') do
      fill_in 'user_email',    with: user.email
      fill_in 'user_password', with: '12345678'
      click_button 'login'
    end
  end

  def logout
    visit root_path
    click_button 'logout'
  end
end

RSpec.configure do |config|
  config.include LoginHelpers, :type => :feature

  config.after(:each) { Warden.test_reset! }
end

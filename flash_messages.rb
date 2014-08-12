# -------------------------------
# (Semi-)Automatic flash messages
# -------------------------------
#
# I like to put flash messages in my i18n YAML files even if my application only supports on
# language because I like to keep most – if not all – of my texts separate from my code. However,
# i18n translations quickly become a mess if you're not very careful about a clean structure for
# your keys. Therefore, I force myself (and other potential team members) to follow a convention.
# To save the mental cycles, I've extracted this convention into a method that can be used in every
# controller.
#
# The strategy is to look up the `success` or `failure` key in a dependent on your controller and
# also provide fallbacks for default translations. For example, if you're in
# `Admin::ProductsController#create`, the fallback chain for the `success` key would be as follows:
#  - flash.admin.products.create.success
#  - flash.products.create.success
#  - flash.create.success
#  - flash.success
#
# At least for the last two options, you probably want to set the appropriate resource name as well
# in the `activerecord.models` or `activemodel.models` scope, e.g. `activerecord.models.product`
# and then interpolate it like so: "%{resource_name} successfully created!"
#
# I originally saw this approach in the Devise gem (https://github.com/plataformatec/devise/blob/master/app/controllers/devise_controller.rb#L131-L161)
# and I've just improved upon it and extended it to my needs – so credit goes to the Plataformatec
# guys.
#
# Usage:
# - Put the code below in `app/controllers/concerns/set_flash_message.rb` and include the concern
#   in any controller where you want to use it (potentially `ApplicationController`).
# - Put appropriate translations into your locale file(s).
# - Call `set_flash_message(:success)` or `set_flash_message(:failure)` in your controller action.
#   Use `:now` as the second argument if you want to use `flash.now` instead of just `flash`.
#   Example:
#     if product.save
#       set_flash_message(:success)
#       redirect_to [:admin, products]
#     else
#       set_flash_message(:failure, :now)
#       render :new
#     end
#
# Note: This assumes your controller responds to `resource_name`. If you don't use a gem that
# makes this method available anyways, just put the following code in your `ApplicationController`
# and override it in other controllers if you need to:
#
#  def resource_name
#    controller_name.singularize
#  end

module SetFlashMessage
  def set_flash_message(status, timing = :after_redirect, options = {})
    flash_key = status == :success ? :notice : :alert
    flash_hash = timing == :now ? flash.now : flash

    full_controller_name = self.class.name.sub(/Controller$/, '').underscore.gsub('/', '.')
    key = :"flash.#{full_controller_name}.#{action_name}.#{status}"
    defaults = [:"flash.#{controller_name}.#{action_name}.#{status}", :"flash.#{action_name}.#{status}", :"flash.#{status}"]

    options.reverse_merge!(:resource_name => I18n.t(resource_name, :scope => 'activerecord.models'), :default => defaults)

    flash_hash[flash_key] = I18n.t(key, options).html_safe
  end
end

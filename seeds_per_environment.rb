# ---------------------
# Seeds per environment
# ---------------------
#
# Seeds are awesome to get an environment into an initial usable state. This facilitates rollouts
# to staging/production but also local development: It is immensely practical to just be able to
# run `rake db:setup` at any point in time to reset the database to its original state and/or check
# that recent changes in the code also work with the app in its bare state. Also, new team members
# can just set up the app within seconds without prior knowledge of the system or having to ask
# another team member to help them.
#
# Rails' default seeds are impractical because they are global for all environments. While there
# certainly is some data that you want in all environments, this isn't necessarily true for *all*
# data. You could use if/case-when blocks per environment but that's kind of annoying as well. So
# this little snippet enables you to have separate seeds per environment and also global seeds for
# all environments.
#
# Usage:
# - Put the code below in db/seeds.rb
# - Put seed data that you want in all environments in `db/seeds/all` and all environment-specific
#   seed data in their respective directory.
# - If you need to run seeds in a specific order, prefix them with numbers (`01-categories.rb`,
#   `02-products.rb` etc.) since they will be sorted alphabetically.
# - Run `rake db:setup` to (re)create your database from scratch.

(Dir[Rails.root.join('db/seeds/all/*.rb')] + Dir[Rails.root.join("db/seeds/#{Rails.env}/*.rb")]).sort.each do |file|
  load file
end

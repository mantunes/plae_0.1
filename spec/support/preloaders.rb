# Avoid errors from preloaders (spring, zeus and so)
#
RSpec.configure do |config|
  config.before(:suite) { FactoryGirl.reload }
end

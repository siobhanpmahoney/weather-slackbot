require_relative '../siobhan_bot.rb'
require_relative './support/vcr_setup.rb'
require_relative './support/siobhan_bot.rb'

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)


RSpec.configure do |config|
  config.tty = true
  config.order = 'default'
end

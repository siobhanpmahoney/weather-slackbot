RSpec.configure do |config|
  config.before do
    SlackRubyBot.config.user = 'siobhan-bot'
  end
end

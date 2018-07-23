require 'spec_helper'

describe SlackRubyBot::Commands::Hi do
  def app
    SiobhanBot::Bot.instance
  end
  it 'says hi' do
    expect(message: 'siobhan-bot hi').to respond_with_slack_message('Hi <@user>!')
  end
end

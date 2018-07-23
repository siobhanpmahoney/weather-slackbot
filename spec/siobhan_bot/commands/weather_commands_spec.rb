require 'spec_helper'
 require 'pry'
 require 'vcr'

describe SlackRubyBot::Commands::WeatherCommands do
  let(:api_response) {WeatherCommands.api_response("today")}

  it 'says hi' do
    expect(message: 'siobhan-bot hi').to respond_with_slack_message('Hi <@user>!')
  end
end

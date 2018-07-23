require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

# an additional command, which advised as to whether or not an umbrella is necessary based on the current and minutely forecast

module SiobhanBot
  module Commands
    class Umbrella < SlackRubyBot::Commands::Base
      command "umbrella?" do |client, data, _match|
        response = JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032/"))
        if response["currently"]["icon"] == "rain" || response["minutely"]["data"].any? {|d| d["precipProbability"] > 0.50 && d["precipType"]=="rain"}
          message = "Looks like rain — don't forget an umbrella! \u{2614}"
        else
          message = "No umbrella needed right now! \u{1f302}"
        end


        client.say(text: "#{message}", channel: data.channel)


      end
    end
  end
end

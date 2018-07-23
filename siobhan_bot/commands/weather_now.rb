require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

module SiobhanBot
  module Commands
    class WeatherNow < SlackRubyBot::Commands::Base
      command "weather now" do |client, data, _match|

        response = JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032?exclude=minutely/"))
        current = response["currently"]
        currentSummary = current["summary"]
        currentTemperature = "#{(current["temperature"]).to_i}°"
        currentPrecipProb = "#{(current["precipProbability"] * 100).to_i}%"
        today = response["daily"]["data"][0]
        todayMaxTemp = today["temperatureMax"].to_i
        todayMaxTime = "#{Time.at(today["temperatureMaxTime"]).strftime("%l:%M %P")}"
        todayMinTemp = "#{(today["temperatureMin"]).to_i}°"
        todayMinTime = "#{Time.at(today["temperatureMinTime"]).strftime("%l:%M %P")}"
        todayPrecipProb = "#{(today["precipProbability"] * 100).to_i}%"

        client.say(text: "#{currentSummary}, with a temperature of #{currentTemperature} and a #{currentPrecipProb} chance of precipiation. Today, you can expect a high of #{todayMaxTemp}° at #{todayMaxTime} and a low of #{todayMinTemp} at #{todayMinTime}.", channel: data.channel)
      end

    end
  end
end

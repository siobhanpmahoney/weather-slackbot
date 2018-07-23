require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

module SiobhanBot
  module Commands
    class WeatherTomorrow < SlackRubyBot::Commands::Base
      command "weather tomorrow" do |client, data, _match|
        tomorrowDate = Time.new(Time.now.year, Time.now.month, (Time.now.day + 1)).to_i
        response = JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032,#{tomorrowDate}?exclude=minutely,hourly/"))["daily"]["data"][0]
        summary = response["summary"]
        maxTemp = (response["temperatureMax"]).to_i
        maxTempTime = "#{Time.at(response["temperatureMaxTime"]).strftime("%l:%M %P")}"
        minTemp =  (response["temperatureMin"]).to_i
        minTempTime = "#{Time.at(response["temperatureMinTime"]).strftime("%l:%M %P")}"
        client.say(text: "#{summary} Expect a high of #{maxTemp}° at #{maxTempTime} and a low of #{minTemp}° at #{minTempTime}.", channel: data.channel)

      end

    end
  end
end

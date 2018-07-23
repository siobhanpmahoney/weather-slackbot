require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

module SiobhanBot
  module Commands
    class WeatherNow < SlackRubyBot::Commands::Base
      command "weather now" do |client, data, _match|

        # response = JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032?exclude=minutely/"))
        response = api_response
        current = response["currently"]
        # currentSummary = currentSummary(current)
        # currentTemperature = "#{(currentSummary["temperature"]).to_i}°"
        # currentPrecipProb = "#{(currentSummary["precipProbability"] * 100).to_i}%"
        today = api_response["daily"]["data"][0]
        # todayMaxTemp = today["temperatureMax"].to_i
        # todayMaxTime = "#{Time.at(today["temperatureMaxTime"]).strftime("%l:%M %P")}"
        # todayMinTemp = "#{(today["temperatureMin"]).to_i}°"
        # todayMinTime = "#{Time.at(today["temperatureMinTime"]).strftime("%l:%M %P")}"
        # todayPrecipProb = "#{(today["precipProbability"] * 100).to_i}%"

        client.say(text: "#{currentSummary(current)}, with a temperature of #{currentTemperature(current)} and a #{currentPrecipProb(current)} chance of precipiation. Today, you can expect a high of #{todayMaxTemp(today)}° at #{todayMaxTime(today)} and a low of #{todayMinTemp(today)} at #{todayMinTime(today)}.", channel: data.channel)
      end



      def self.api_response
        JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032?exclude=minutely/"))
      end

      def self.currentSummary(obj)
        obj["summary"]
      end

      def self.currentTemperature(obj)
        "#{(obj["temperature"]).to_i}°"
      end

      def self.currentPrecipProb(obj)
        "#{(obj["precipProbability"] * 100).to_i}%"
      end

      def self.todayMaxTemp(obj)
        obj["temperatureMax"].to_i
      end

      def self.todayMaxTime(obj)
        "#{Time.at(obj["temperatureMaxTime"]).strftime("%l:%M %P")}"
      end

      def self.todayMinTemp(obj)
        "#{(obj["temperatureMin"]).to_i}°"
      end

      def self.todayMinTime(obj)
        "#{Time.at(obj["temperatureMinTime"]).strftime("%l:%M %P")}"
      end

      def self.todayPrecipProb(obj)
        "#{(obj["precipProbability"] * 100).to_i}%"
      end




    end
  end
end

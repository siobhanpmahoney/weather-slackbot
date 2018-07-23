require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

# "weather now" and "weather tomorrow" command definitions

module SiobhanBot
  module Commands
    class WeatherCommands < SlackRubyBot::Commands::Base

      command "weather tomorrow" do |client, data, _match|
        response = api_response(tomorrow_date)
        client.say(text: "#{summary(response)} Expect a high of #{max_temp(response)}° at #{max_temp_time(response)} and a low of #{min_temp(response)}° at #{min_temp_time(response)}.", channel: data.channel)
      end

      command "weather now" do |client, data, _match|
        response = api_response("today")
        current = response["currently"]
        today = response["daily"]["data"][0]
        client.say(text: "#{summary(current)}, with a temperature of #{current_temperature(current)} and a #{current_precip_prob(current)} chance of precipiation. Today, you can expect a high of #{max_temp(today)}° at #{max_temp_time(today)} and a low of #{min_temp(today)} at #{min_temp_time(today)}, with a #{today_precip_prob(today)} chance of precipitation.", channel: data.channel)
      end



      # shared helper methods refactored to facilitate testing

      def self.tomorrow_date
        Time.new(Time.now.year, Time.now.month, (Time.now.day + 1)).to_i
      end

      def self.api_response(date)
        if date == "today"
          JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032?exclude=minutely/"))
        else
          JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032,#{tomorrow_date}?exclude=minutely,hourly/"))["daily"]["data"][0]
        end
      end

      def self.summary(obj)
        obj["summary"]
      end

      def self.current_temperature(obj)
        "#{(obj["temperature"]).to_i}°"
      end

      def self.current_precip_prob(obj)
        "#{(obj["precipProbability"] * 100).to_i}%"
      end

      def self.max_temp(obj)
        (obj["temperatureMax"]).to_i
      end

      def self.max_temp_time(obj)
        "#{Time.at(obj["temperatureMaxTime"]).strftime("%l:%M %P")}"
      end

      def self.min_temp(obj)
        (obj["temperatureMin"]).to_i
      end

      def self.min_temp_time(obj)
        "#{Time.at(obj["temperatureMinTime"]).strftime("%l:%M %P")}"
      end

      def self.today_precip_prob(obj)
        "#{(obj["precipProbability"] * 100).to_i}%"
      end



    end
  end
end

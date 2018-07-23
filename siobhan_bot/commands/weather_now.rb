require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

module SiobhanBot
  module Commands
    class WeatherNow < SlackRubyBot::Commands::Base
      command "weather now" do |client, data, _match|

        response = api_response
        current = response["currently"]
        today = response["daily"]["data"][0]

        client.say(text: "#{current_summary(current)}, with a temperature of #{current_temperature(current)} and a #{current_precip_prob(current)} chance of precipiation. Today, you can expect a high of #{today_max_temp(today)}° at #{today_max_time(today)} and a low of #{today_min_temp(today)} at #{today_min_time(today)}, with a #{today_precip_prob(today)}% chance of precipitation.", channel: data.channel)
      end



      def self.api_response
        JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032?exclude=minutely/"))
      end

      def self.current_summary(obj)
        obj["summary"]
      end

      def self.current_temperature(obj)
        "#{(obj["temperature"]).to_i}°"
      end

      def self.current_precip_prob(obj)
        "#{(obj["precipProbability"] * 100).to_i}%"
      end

      def self.today_max_temp(obj)
        obj["temperatureMax"].to_i
      end

      def self.today_max_time(obj)
        "#{Time.at(obj["temperatureMaxTime"]).strftime("%l:%M %P")}"
      end

      def self.today_min_temp(obj)
        "#{(obj["temperatureMin"]).to_i}°"
      end

      def self.today_min_time(obj)
        "#{Time.at(obj["temperatureMinTime"]).strftime("%l:%M %P")}"
      end

      def self.today_precip_prob(obj)
        "#{(obj["precipProbability"] * 100).to_i}%"
      end




    end
  end
end

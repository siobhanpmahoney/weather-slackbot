require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'config/api_keys'

module SiobhanBot
  module Commands
    class WeatherTomorrow < SlackRubyBot::Commands::Base

      command "weather tomorrow" do |client, data, _match|
        client.say(text: "#{summary} Expect a high of #{max_temp}° at #{max_temp_time} and a low of #{min_temp}° at #{min_temp_time}.", channel: data.channel)
      end

      def self.tomorrow_date
        Time.new(Time.now.year, Time.now.month, (Time.now.day + 1)).to_i
      end

      def self.api_response
         JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032,#{tomorrow_date}?exclude=minutely,hourly/"))["daily"]["data"][0]
      end

      def self.summary
        api_response["summary"]
      end

      def self.max_temp
        (api_response["temperatureMax"]).to_i
      end

      def self.max_temp_time
        "#{Time.at(api_response["temperatureMaxTime"]).strftime("%l:%M %P")}"
      end

      def self.min_temp
        (api_response["temperatureMin"]).to_i
      end

      def self.min_temp_time
        "#{Time.at(api_response["temperatureMinTime"]).strftime("%l:%M %P")}"
      end

    end
  end
end

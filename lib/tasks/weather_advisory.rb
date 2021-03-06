require 'slack-ruby-bot'
require 'rest-client'
require 'json'
require_relative '../../config/api_keys'


# daily check comparing day's forecast to that of the day before

namespace :weather_advisory do
  desc "Rake task to fetch morning weather"
  task :fetch do

    # today's forecast data:

    weather_today=JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032?exclude=minutely/"))["daily"]["data"][0]


    #yesterday's forecast data:

    yesterday = Time.new(Time.now.year, Time.now.month, (Time.now.day - 1)).to_i

    weather_yesterday = JSON.parse(RestClient.get("https://api.darksky.net/forecast/#{DARK_SKY_API_KEY}/40.710740,-74.007032,#{yesterday}?exclude=minutely/"))["daily"]["data"][0]


    # hash of data to compare: includes precipitation probability, temperature low, and temperature max

    summary = {
      precipProbability: {
        today: (weather_today["precipProbability"] * 100).to_i,
        yesterday: (weather_yesterday["precipProbability"] * 100).to_i,
        units: "%",
        opening: "Chance of precipitation today: "
      },
      temperatureMin: {
        today: (weather_today["temperatureMin"]).to_i,
        yesterday: (weather_yesterday["temperatureMin"]).to_i,
        units: "°",
        opening: "Today's Low: "
      },
      temperatureMax: {
        today: (weather_today["temperatureMax"]).to_i,
        yesterday: (weather_yesterday["temperatureMax"]).to_i,
        units: "°",
        opening: "Today's High: "
      }
    }


    # comparing yesterday and today's data: if the difference in precipiation probability or tempeature min/max is over 10% or 10° respectively, an advisory statement is added to a comparison array

    comparison = summary.map do |key, value|
      if (value[:today] - value[:yesterday]).abs >= 10
        diff = (value[:today] - value[:yesterday]).abs
        compare_term = value[:today] > value[:yesterday] ? "higher" : "lower"
        "#{value[:opening]} #{value[:today]}#{value[:units]} (#{diff}#{value[:units]} #{compare_term} than yesterday)."
      else
        nil
      end
    end.compact


    ## if the comparison array is not empty (meaning there is a weather advisory to broadcast), the update will be posted to the Siobhan-Channel
    puts comparison.length
    puts comparison
    if comparison.length > 0
      updates = comparison.join(" ")
      advisory = "#{updates}"
      payload = JSON.generate({
        channel: "GBT2B6GFK",
        text: "WEATHER ADVISORY: #{advisory}",
        as_user: true,
        username: "siobhan-bot"
        })
        response = RestClient.post("https://slack.com/api/chat.postMessage", payload, { "Authorization": "Bearer #{SLACK_TOKEN}", "Content-Type": "application/json", "Accept-Charset": "text/plain"})
      end
    end
  end

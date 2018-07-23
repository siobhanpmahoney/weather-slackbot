# Weather SlackBot

## Requirements:

- [Slack-Ruby-Bot](https://github.com/slack-ruby/slack-ruby-bot#slack-ruby-bot): framework used for automated SlackBot responses.
- [Whenever](https://github.com/javan/whenever): gem used to schedule tasks

## Getting Started

The bot relies on the Bot Class and Command class(es).

To get started, I created a file `siobhan_bot.rb` in the root directory, where the commands and Bot class will be required:

```rb

require 'slack-ruby-bot'
require 'RestClient'
require 'json'
require 'siobhan_bot/bot'
require 'siobhan_bot/commands'

```

Also in the root directory, is a `run.rb` file, which will be used to run the bot:

```rb
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'siobhan_bot'

begin
  SiobhanBot::Bot.run
end
```

The bot is defined in `siobhan_bot/bot.rb`:

```rb
module SiobhanBot
  class Bot < SlackRubyBot::Bot
  end
end
```

## Commands

The commands are defined in the `siobhan_bot/commands` directory and with the following architecture:

```rb

module SiobhanBot
  module Commands
    class Command_Name < SlackRubyBot::Commands::Base

      command "command bot should respond to" do |client, data, _match|
        client.say(text: "bot's response", channel: data.channel)
      end
    end
  end

```

Here, we are defining the words or phrase to trigger a bot action as well as defining the action itself. In addition to defining the command, we are also passing three arguments:

- `client` refers to the Slack client that makes it possible for the bot to communicate with a given channel.
- `data` wraps the relevant information about the communication, including the message content, message type, sender id, channel, and team in a hash.
- `match` allows for a less strict approach to catching commands, including pattern matching


#### Building `weather now` and `weather tomorrow` commands:

Since the bot accesses a similar set of data points in response to the `weather now` and `weather tomorrow` commands (e.g., `temperatureMin`, `temperatureMax`, `precipProbability`), I grouped them together within the `WeatherCommands` class and wrote a collection of helper methods to extract the relevant information from the respective responses. (see `siobhan-bot/commands/weather_commands.rb`)  

### Registering SiobhanBot

After building the Bot and Bot Commands, I then registered the bot by running the following:

```
SLACK_API_TOKEN=[API_TOKEN] bundle exec ruby run.rb
```

## Scheduling Weather Updates

To schedule advisories about fluctuations in weather patterns between a day and the day before, I used the `whenever` gem, which allows for the scheduling of rake tasks based on a given time or interval.

Once the `whenever` gem is installed, running `wheneverize .` will create a `schedule.rb` file in `/config`.  Here is where the Bot's automated tasks will be managed.  For a daily weather forecast check, I wrote the following:

```rb
set :output, 'log/whenever.log'
every 1.day, at: '7:30 am' do
  rake "weather_advisory:fetch"
end
```


### Building the `weather_advisory` task
The schedule references the `weather_advisory` task defined in `/lib/tasks/weather_advisory.rb`.  `weather_advisory` makes two calls to the Dark Sky API and then compares the data provided for the following:
- precipitation probability
- minimum temperature
- maximum temperature

If either temperature fluctuates by 10° or more, or if the likelihood of precipitation fluctuates by 10% or more, a weather advisory is broadcast to Siobhan-Channel via a `RestClient.post` request:

```rb
response = RestClient.post("https://slack.com/api/chat.postMessage", payload, { "Authorization": "Bearer #{SLACK_TOKEN}", "Content-Type": "application/json", "Accept-Charset": "text/plain"})
```

If there is not a fluctuation in either precipitation likelihood or temperature high or low, the bot does not broadcast a message.

Additionally, any time a task is run, the output is logged in `/logs/whenever.log` (which is listed in the `.gitignore` file due to exposure of API keys)

## Bonus Command
`SiobhanBot` will respond to an additional bonus command: by running "umbrella?", the bot will make a call to the Dark Sky API and let you know if you need an umbrella based on the current precipitation status and/or the minutely forecast.

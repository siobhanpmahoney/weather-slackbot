$LOAD_PATH.unshift(File.dirname(__FILE__))


require 'siobhan_bot'



# to run SiobhanBot, run SLACK_API_TOKEN=[SLACK_TOKEN] bundle exec ruby run.rb in your console

begin
  SiobhanBot::Bot.run

end

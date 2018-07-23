

# determines when to run weather_advisory task (defined in lib/tasks/weather_advisory.rb)


set :output, 'log/whenever.log'
every 1.day, at: '7:30 am' do
  rake "weather_advisory:fetch"
end


# for testing purposes, it is helpful to run your command on a 1-minute interval

# set :output, 'log/whenever.log'
# every 1.minute do
#   rake "weather_advisory:fetch"
# end

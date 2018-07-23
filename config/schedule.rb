
# 
# set :output, 'log/whenever.log'
# every 1.day, at: '7:30 am' do
#   rake "weather_advisory:fetch"
# end
#

set :output, 'log/whenever.log'
every 1.minute do
  rake "weather_advisory:fetch"
end

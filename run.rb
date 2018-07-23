$LOAD_PATH.unshift(File.dirname(__FILE__))


require 'siobhan_bot'

begin
  SiobhanBot::Bot.run

end

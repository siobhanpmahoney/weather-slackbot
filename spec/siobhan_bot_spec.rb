require 'spec_helper'
require_relative 'spec_helper'
require 'pry'
require 'vcr'

describe SiobhanBot::Bot do

  subject(:app) { SiobhanBot::Bot.instance }

  it_behaves_like 'a slack ruby bot'
end

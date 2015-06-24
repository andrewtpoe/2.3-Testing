require 'minitest/autorun'

require './classes/user'
require './classes/machine'
require './classes/program'

class TestUser < MiniTest::Unit::TestCase
  def setup
    @user = User.new
  end


end

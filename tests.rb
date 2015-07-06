require 'minitest/autorun'

require './classes/user'
require './classes/machine'
require './classes/program'

class TestUser < MiniTest::Test
  def setup
    @user = User.new
    @user.balance = 200
    @amount = 50
  end

  def test_has_enough_money
    amount = 500
    assert_equal false, @user.can_withdraw?(amount)
  end

  def test_amount_more_than_zero
    amount = 0
    assert_equal false, @user.can_withdraw?(amount)
  end

  def test_amount_equals_Fixnum
    amount = ""
    assert_equal false, @user.can_withdraw?(amount)
  end

  def test_can_user_withdraw
    assert_equal true, @user.can_withdraw?(@amount)
  end

  def test_deduct_works
    assert_equal (@user.balance - @amount), @user.deduct(@amount)
  end

end

class TestMachine < MiniTest::Test
  def setup
    @machine = Machine.new
    @machine.balance = 200
    @amount = 50
  end

  def test_has_enough_money
    amount = 500
    assert_equal false, @machine.can_withdraw?(amount)
  end

  def test_amount_more_than_zero
    amount = 0
    assert_equal false, @machine.can_withdraw?(amount)
  end

  def test_amount_equals_Fixnum
    amount = ""
    assert_equal false, @machine.can_withdraw?(amount)
  end

  def test_can_user_withdraw
    assert_equal true, @machine.can_withdraw?(@amount)
  end

  def test_deduct_works
    assert_equal (@machine.balance - @amount), @machine.deduct(@amount)
  end

end

class TestProgram  < MiniTest::Test
  def setup
    @atm = Machine.new
    @atm.balance = 100000
    @user = User.new
    @p = Program.new(@atm)
    @p.user = @user
  end

  # Testing run method
  def test_run_fails_with_invalid_menu_entry
    response = {}
    @p.stub(:get_menu_selection, 10) do
      response = @p.run
    end
    assert_equal true, response.has_key?(:error)
  end

  # Test get_input(prompt) method
  def test_get_input_works
    response = ""
    @p.stub(:chomp, "test string") do
      response = @p.get_input("this is a test")
    end
    assert_match "test string", response
  end

  # Test get_login_info method
  def test_login_name
    login = {}
    @p.stub(:chomp, "Andrew") do
      login = @p.get_login_info
    end
    assert_equal "Andrew", login[:name]
    assert_equal "Andrew", login[:pin]
  end

  # Test get_menu_selection(menu)
  def test_returns_menu_selection_in_range
    menu_arr = ["1", "2", "3"]
    menu_sel = nil
    @p.stub(:get_input, 1) do
      menu_sel = @p.get_menu_selection(menu_arr)
    end
    assert_equal 1, menu_sel
  end

  # Test get_user(login)

  # Test show_acc_menu

  # Test withdraw_funds
  def test_withdraw_works
    @p.user.balance = 200
    @p.atm.balance = 500
    response = {}
    amount = @p.stub(:get_input, 20) do
      response = @p.withdraw_funds
    end
    assert_equal false, response.has_key?(:error)
  end

  def test_can_not_withdraw_negative
    response = {}
    amount = @p.stub(:get_input, -10) do
      response = @p.withdraw_funds
    end
    assert_equal true, response.has_key?(:error)
  end

  def test_user_has_insufficient_funds
    @p.user.balance = 20
    @p.atm.balance = 500
    response = {}
    amount = @p.stub(:get_input, 50) do
      response = @p.withdraw_funds
    end
    assert_equal true, response.has_key?(:error)
  end

  def test_atm_has_insufficient_funds
    @p.user.balance = 5000
    @p.atm.balance = 50
    response = {}
    amount = @p.stub(:get_input, 500) do
      response = @p.withdraw_funds
    end
    assert_equal true, response.has_key?(:error)
  end

  # Test parse_data_file
  def test_user_data_file_exists
    assert_equal true, File.exist?('./user-data/users.csv')
  end

  # Test update_data_file
end

require_relative "test_helper"

class LogBookTest < MiniTest::Unit::TestCase
  def setup
    HistoryEvent::Model.destroy_all
    User.destroy_all
    Item.destroy_all

    @user = User.create!(:name => "User Name")
    @item = Item.create!(:title => "Item Title")
  end

  def test_event_on_create
    item = Item.new(:last_event_historian => @user)
    HistoryEvent.expects(:created).with(@user, item)
    item.save!
  end

  def test_event_on_update
    @item.last_event_historian = @user
    HistoryEvent.expects(:updated).with(@user, @item)
    @item.update_attributes(:title => "Other Title")
  end

  def test_event_on_destroy
    @item.last_event_historian = @user
    HistoryEvent.expects(:destroyed).with(@user, @item)
    @item.destroy
  end
end


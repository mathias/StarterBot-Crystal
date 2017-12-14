require "spec"
require "../../hlt/game.cr"

def create_test_object(name)
  Game.new(name)
end

describe "Game" do
  it "can be created" do
    game = create_test_object(name: "SimpleBot")
    game.should_not be_nil
  end
end

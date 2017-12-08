require "spec"
require "../hlt/game.cr"

def create_test_object(name)
  Game.new(name)
end

# spec/my_project_spec.cr
#require "./spec_helper"

describe "Game" do
  it "can be created" do
    game = create_test_object(name: "SimpleBot")
    game.should_not be_nil
  end
end


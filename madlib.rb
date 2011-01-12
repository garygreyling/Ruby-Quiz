#!/usr/bin/ruby
require 'game'

module Madlib
  extend self

  def play
    game = Madlib::Game.new
    game.get_sentance
    game.ask_for_inputs
    game.display_madlib
  end
end

Madlib.play
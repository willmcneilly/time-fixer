Level1 = require './level-1'
Level2 = require './level-2'

module.exports = class TimeFixerGame
  constructor: () ->
    @game = new Phaser.Game 800, 600, Phaser.AUTO
    @registerStates()

  registerStates: ->
    @game.state.add('level1', new Level1(@game), true)
    @game.state.add('level2', new Level2(@game))

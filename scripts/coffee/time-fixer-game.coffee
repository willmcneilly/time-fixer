Level1 = require './level-1'

module.exports = class TimeFixerGame
  constructor: () ->
    @game = new Phaser.Game 800, 600, Phaser.AUTO
    @registerStates()

  registerStates: ->
    @game.state.add('level', new Level1(@game), true)

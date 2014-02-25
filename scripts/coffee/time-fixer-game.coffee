TimeFixerBaseLevel = require './time-fixer-base-level'

module.exports = class TimeFixerGame
  constructor: () ->
    @game = new Phaser.Game 800, 600, Phaser.AUTO
    @registerStates()

  registerStates: ->
    @game.state.add('level', new TimeFixerBaseLevel(@game), true)

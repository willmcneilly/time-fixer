TimeFixerBaseLevel = require './time-fixer-base-level'

module.exports = class Level2 extends TimeFixerBaseLevel
  constructor: (game) ->
    super game
    @numTimelords = 4
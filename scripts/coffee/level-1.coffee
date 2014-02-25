TimeFixerBaseLevel = require './time-fixer-base-level'

module.exports = class Level1 extends TimeFixerBaseLevel
  constructor: (game) ->
    super game
    @numTimelords = 2

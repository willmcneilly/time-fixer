Timelord = require './timelord'

module.exports = class TimeFixerBaseLevel
  constructor: (game) ->
    @game = game
    @numTimelords = 5
    @timelords = null
    @playerControlledTimelord = null
    @playerControlledTimelordNum = null
    @respawnTime = 10
    @respawnPause = 5

  preload: ->
    @game.load.image 'sky', '/assets/images/sky.png'
    @game.load.image 'ground', '/assets/images/platform.png'
    @game.load.image 'star', '/assets/images/star.png'
    @game.load.spritesheet 'dude', '/assets/images/dude.png', 32, 48

  create: =>
    @createWorld()
    @createStars()
    @cursors = @game.input.keyboard.createCursorKeys()
    @createTimelords(@numTimelords)
    @initTimelords()

    @scoreText = @game.add.text 16, 16, 'score: 0', font: '32px arial', fill: '#000'
    @timer = new Phaser.Timer(@game)
    @timer.start()

  clearTimer: ->
    @timer.stop()
    @timer = new Phaser.Timer(@game)
    @timer.start()

  update: =>
    if @timer.seconds() > @respawnTime
      @clearTimer()
      for timelord in @timelords
        timelord.currentMove = 0
      if @playerControlledTimelord is undefined
        return
      @playerControlledTimelord.playerControlled = false
      @playerControlledTimelord.pastControlled = true
      @playerControlledTimelord.futureControlled = false
      @playerControlledTimelordNum = @playerControlledTimelordNum + 1
      
      @playerControlledTimelord = @timelords[@playerControlledTimelordNum]
      if @playerControlledTimelord is undefined
        return
      @playerControlledTimelord.playerControlled = true
      @playerControlledTimelord.futureControlled = false
      

    for timelord in @timelords 
      @game.physics.collide timelord.sprite, @platforms
      timelord.update()

  createTimelords: (num) ->
    @timelords = []
    for i in [0..num-1]
      opts = {}
      opts.spawnPosition = {
        x: @game.world.width * Math.random(),
        y: @game.world.height * Math.random()
      }
      timelord = new Timelord(@game, @cursors, opts)
      timelord.playerControlled = false
      timelord.futureControlled = true
      timelord.pastControlled = false
      timelord.id = i
      @timelords.push(timelord)

  initTimelords: ->
    # set the first timelord to be player controlled
    @playerControlledTimelordNum = 0
    @timelords[@playerControlledTimelordNum ].playerControlled = true
    @timelords[@playerControlledTimelordNum ].futureControlled = false
    @playerControlledTimelord = @timelords[@playerControlledTimelordNum]


  createWorld: ->
    @game.add.sprite 0, 0, 'sky'
    @platforms = @game.add.group()
    @ground = @platforms.create 0, @game.world.height - 64, 'ground'
    @ground.scale.setTo 2, 2
    @ground.body.immovable = true

    @ledge = @platforms.create 400, 400, 'ground'
    @ledge.body.immovable = true

    @ledge = @platforms.create -150, 250, 'ground'
    @ledge.body.immovable = true

  createStars: =>
    @game.add.sprite 0, 0, 'star'
    @stars = @game.add.group() 
    for i in [0..12]
      star = @stars.create i * 70, 0, 'star'
      star.body.gravity.y = 6
      star.body.bounce.y = 0.7 + Math.random() * 0.2
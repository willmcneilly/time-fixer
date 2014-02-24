console.log 'hello phaser'

class TimeFixerGame
  constructor: () ->
    @game = new Phaser.Game 800, 600, Phaser.AUTO, '', preload: @preload, create: @create, update: @update
    @numTimelords = 5
    @timelords = null
    @playerControlledTimelord = null
    @playerControlledTimelordNum = null
    @respawnTime = 10

  preload: ->
    console.log ':preload'
    @game.load.image 'sky', '/assets/images/sky.png'
    @game.load.image 'ground', '/assets/images/platform.png'
    @game.load.image 'star', '/assets/images/star.png'
    @game.load.spritesheet 'dude', '/assets/images/dude.png', 32, 48

  create: =>
    console.log ':create'
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
      console.log(@timer.seconds())
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
      timelord = new TimeLord(@game, @cursors)
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
      

      


class TimeLord
  constructor: (game, cursors) ->
    # reference to main game object
    @game = game
    # Has movement history, controlled by computer
    @pastControlled = false

    # Has yet to spawn 
    @futureControlled = true
    
    # Currently controlled by player
    @playerControlled = false
    # Movement Data
    @movementHistory = []
    @currentMove = 0
    @sprite = null
    @cursors = cursors
    @velocity = 150
    @id = null
    @create()
    
  create: ->
    @sprite = @game.add.sprite 32, @game.world.height - 150, 'dude'
    @sprite.body.gravity.y = null
    @sprite.body.collideWorldBounds = true

    @sprite.animations.add 'left', [0..3], 10, true
    @sprite.animations.add 'right', [5..8], 10, true

  update: ->
    @sprite.body.velocity.x = 0
    @sprite.body.velocity.y = 0

    timelordPos = {
      x: @sprite.x
      y: @sprite.y
    }

    if @playerControlled
      @sprite.alpha = 1
      if @cursors.left.isDown
        @sprite.body.velocity.x = -@velocity
        @sprite.animations.play 'left'
        timelordPos['name'] = 'leftDown'       
      else if @cursors.right.isDown
        @sprite.body.velocity.x = @velocity
        @sprite.animations.play 'right'
        timelordPos['name'] = 'rightDown'
      else if @cursors.up.isDown
        @sprite.body.velocity.y = -@velocity
        timelordPos['name'] = 'upDown'
      else if @cursors.down.isDown
        @sprite.body.velocity.y = @velocity
        timelordPos['name'] = 'downDown'
      else
        @sprite.animations.stop()
        @sprite.frame = 4
        timelordPos['name'] = 'none'

      @movementHistory.push(timelordPos)

    else if @pastControlled
      @sprite.alpha = 0.5
      movement = @movementHistory[@currentMove]
      if movement is undefined
        @currentMove = 0
        return

      @sprite.body.velocity.x = 0
      @sprite.body.velocity.y = 0
      if(movement.name == 'leftDown')
        @sprite.body.velocity.x = -150
        @sprite.animations.play 'left'
      else if (movement.name == 'rightDown')
        @sprite.body.velocity.x = 150
        @sprite.animations.play 'right'
      else if (movement.name == 'upDown')
        @sprite.body.velocity.y = -150
      else if (movement.name == 'downDown')
        @sprite.body.velocity.y = 150
      else if (movement.name == 'up')
        @sprite.body.velocity.y = -350
      else
        @sprite.animations.stop()
        @sprite.frame = 4

      if @sprite.x != movement.x
        @sprite.x = movement.x

      if @sprite.y != movement.y
        @sprite.y = movement.y

      @currentMove = @currentMove + 1

    if @futureControlled
      @sprite.alpha = 0


game = new TimeFixerGame()

console.log 'hello phaser'

class TimeFixerGame
  constructor: () ->
    @game = new Phaser.Game 800, 600, Phaser.AUTO, '', preload: @preload, create: @create, update: @update
    @numTimelords = 5
    @timelords = null
    @playerControllerTimelord = null
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

  update: =>
    if @timer.seconds() > @respawnTime
      @playerControllerTimelord.playerControlled = false
      @playerControlled = @timelords[1]
      @playerControlled.playerControlled = true
      @playerControlled.active = true

    for timelord in @timelords 
      @game.physics.collide timelord.sprite, @platforms
      timelord.update()

  createTimelords: (num) ->
    @timelords = []
    for i in [0..num]
      timelord = new TimeLord(@game, @cursors)
      timelord.playerControlled = false
      timelord.active = false
      @timelords.push(timelord)

  initTimelords: ->
    # set the first timelord to be player controlled
    @timelords[0].playerControlled = true
    @timelords[0].active = true
    @playerControllerTimelord = @timelords[0]

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
    # shown on screen
    @active = false
    # controlled by player
    @playerControlled = false
    # Movement Data
    @movementHistory = []
    @sprite = null
    @cursors = cursors
    @velocity = 150
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

    if @playerControlled and @active
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

    else if not @playerControlled and @active

      movement = @movementHistory[0]
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

      @movementHistory.shift()




# preload = ->
#   console.log ':preload'
#   game.load.image 'sky', '/assets/images/sky.png'
#   game.load.image 'ground', '/assets/images/platform.png'
#   game.load.image 'star', '/assets/images/star.png'
#   game.load.spritesheet 'dude', '/assets/images/dude.png', 32, 48

# platforms = null
# player = null
# player2 = null
# playerMovement = []
# cursors = null
# stars = null
# scoreText = null
# score = 0
# timer = null

# create = ->
#   console.log ':create'
#   game.add.sprite 0, 0, 'sky'
#   platforms = game.add.group()
#   ground = platforms.create 0, game.world.height - 64, 'ground'
#   ground.scale.setTo 2, 2
#   ground.body.immovable = true

#   ledge = platforms.create 400, 400, 'ground'
#   ledge.body.immovable = true

#   ledge = platforms.create -150, 250, 'ground'
#   ledge.body.immovable = true

#   game.add.sprite 0, 0, 'star'
#   cursors = game.input.keyboard.createCursorKeys()
#   player = new TimeLord(game, cursors)
#   player.playerControlled = true

#   player2 = game.add.sprite 32, game.world.height - 150, 'dude'

#   player2.alpha = 0.5


#   player2.body.gravity.y = null
#   player2.body.collideWorldBounds = true



#   player2.animations.add 'left', [0..3], 10, true
#   player2.animations.add 'right', [5..8], 10, true

  
#   stars = game.add.group()
 
#   for i in [0..12]
#     star = stars.create i * 70, 0, 'star'
#     star.body.gravity.y = 6
#     star.body.bounce.y = 0.7 + Math.random() * 0.2

#   scoreText = game.add.text 16, 16, 'score: 0', font: '32px arial', fill: '#000'

#   timer = new Phaser.Timer(game)
#   timer.start()

# collectStar = (player, star)->
#   star.kill()
#   score += 10
#   scoreText.content = "Score: #{score}"

# movePlayer2 = ->

#   movement = playerMovement[0]
#   player2.body.velocity.x = 0
#   player2.body.velocity.y = 0
#   if(movement.name == 'leftDown')
#     player2.body.velocity.x = -150
#     player2.animations.play 'left'
#   else if (movement.name == 'rightDown')
#     player2.body.velocity.x = 150
#     player2.animations.play 'right'
#   else if (movement.name == 'upDown')
#     player2.body.velocity.y = -150
#   else if (movement.name == 'downDown')
#     player2.body.velocity.y = 150
#   else if (movement.name == 'up')
#     player2.body.velocity.y = -350
#   else
#     player2.animations.stop()
#     player2.frame = 4

#   if player2.x != movement.x
#     player2.x = movement.x

#   if player2.y != movement.y
#     player2.y = movement.y

#   playerMovement.shift()

# update = ->
#   player.update()
#   debugger
  # game.physics.collide player, platforms
  # game.physics.collide player2, platforms
  # game.physics.collide stars, platforms
  # game.physics.overlap player, stars, collectStar, null, this

  # player.body.velocity.x = 0
  # player.body.velocity.y = 0

  # playerPos = {
  #   x: player.x
  #   y: player.y
  # }
  # if cursors.left.isDown
  #   player.body.velocity.x = -150
  #   player.animations.play 'left'
  #   playerPos['name'] = 'leftDown'
    
  # else if cursors.right.isDown
  #   player.body.velocity.x = 150
  #   player.animations.play 'right'
  #   playerPos['name'] = 'rightDown'

  # else if cursors.up.isDown
  #   player.body.velocity.y = -150
  #   playerPos['name'] = 'upDown'

  # else if cursors.down.isDown
  #   player.body.velocity.y = 150
  #   playerPos['name'] = 'downDown'
  # else
  #   player.animations.stop()
  #   player.frame = 4
  #   playerPos['name'] = 'none'

  # playerMovement.push(playerPos)

  # if cursors.up.isDown && player.body.touching.down
  #   player.body.velocity.y = -350
  #   playerMovement.push('up')

  # if game.time.totalElapsedSeconds() > 5
  #   movePlayer2()

game = new TimeFixerGame()

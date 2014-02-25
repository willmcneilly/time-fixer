module.exports = class TimeLord
  constructor: (game, cursors, opts = {}) ->
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
    @spawnPosition = opts.spawnPosition ? {x: 32, y: 450}
    @id = null
    @create()
    
  create: ->
    @sprite = @game.add.sprite @spawnPosition.x, @spawnPosition.y, 'dude'
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
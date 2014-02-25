module.exports = class Timelord
  constructor: (game, cursors, opts = {}) ->
    @game = game
    @cursors = cursors

    @velocity = opts.velocity ? 150
    @spawnPosition = opts.spawnPosition ? {x: 32, y: 450} 
    @movementHistory = []
    @currentMove = 0
    @sprite = null
    @id = null
    @currentState = null

    @create()
    
  create: ->
    @sprite = @game.add.sprite @spawnPosition.x, @spawnPosition.y, 'dude'
    @sprite.body.gravity.y = null
    @sprite.body.collideWorldBounds = true

    @sprite.animations.add 'left', [0..3], 10, true
    @sprite.animations.add 'right', [5..8], 10, true
    @setStateTo('futureControlled')

  update: ->
    @manageState()    

  manageState: ->
    switch @currentState
      when 'playerControlled' then @playerContolledState()
      when 'pastControlled' then @pastControlledState()
      when 'futureControlled' then @futureControlledState()  

  setStateTo: (stateName) ->
    switch stateName
      when 'playerControlled' then @triggerPlayerContolledState()
      when 'pastControlled' then @triggerPastControlledState()
      when 'futureControlled' then @triggerFutureControlledState()

  triggerPlayerContolledState: ->
    console.log('triggerPlayerContolledState:')
    @currentState = 'playerControlled'
    @sprite.alpha = 1

  playerContolledState: ->
    @sprite.body.velocity.x = 0
    @sprite.body.velocity.y = 0

    timelordPos = {
      x: @sprite.x
      y: @sprite.y
    }

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

  triggerPastControlledState: ->
    console.log('triggerPastControlledState:')
    @currentState = 'pastControlled'
    @sprite.alpha = 0.5

  pastControlledState: ->
    movement = @movementHistory[@currentMove]
    @sprite.alpha = 0.5
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

  triggerFutureControlledState: ->
    console.log('triggerFutureControlledState:')
    @currentState = 'futureControlled'
    @sprite.alpha = 0

  futureControlledState: ->

  stopSpriteMovement: ->
    @sprite.body.velocity.x = 0
    @sprite.body.velocity.y = 0
    @sprite.animations.stop()
    @sprite.alpha = 0



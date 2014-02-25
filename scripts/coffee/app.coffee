TimeFixerGame = require './time-fixer-game'
StateMachine = require './state-machine'
#game = new TimeFixerGame()

prePlayerControlled = ->
  console.log('prePlayerControlled')

postPlayerControlled = ->
  console.log('postPlayerControlled')

prePlayerControlledRemoved = ->
  console.log('prePlayerControlled Removed')

postPlayerControlledRemoved = ->
  console.log('postPlayerControlled Removed')

prePastControlled = ->
  console.log('prePastControlled')

postPastControlled = ->
  console.log('postPastControlled')

preFutureControlled = ->
  console.log('preFutureControlled')

postFutureControlled = ->
  console.log('postFutureControlled')

preHidden = ->
  console.log('preHiddenControlled')

postHidden = ->
  console.log('postHiddenControlled')


stateMachineOptions = [
  {
    name: 'playerControlled'
    pre: prePlayerControlled
    post: postPlayerControlled
    preRemove: prePlayerControlledRemoved
    postRemove: postPlayerControlledRemoved
  },
  {
    name: 'pastControlled'
    pre: prePastControlled
    post: postPastControlled
  },
  {
    name: 'futureControlled'
    pre: preFutureControlled
    post: postFutureControlled
  },
  {
    name: 'hidden'
    pre: preHidden
    post: postHidden
  }
]

stateMachine = new StateMachine(stateMachineOptions)
stateMachine.setState('playerControlled')
debugger
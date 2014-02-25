module.exports = class StateMachine
  
  constructor: (states) ->
    @states = states
    @activeStates = []

  setState: (stateName) ->
    unless @isActive(stateName)
      @triggerPreState(stateName)
      @activeStates.push(stateName)
      @triggerPostState(stateName)

  removeState: (stateName) ->
    if @isActive(stateName)
      @triggerPreStateRemove(stateName)
      _.pull(@activeStates, stateName)
      @triggerPostStateRemove(stateName)

  getStates: ->
    @activeStates

  isActive: (stateName) ->
    found = _.find @activeStates, (state) ->
      return state == stateName
    if found
      return true
    else 
      return false

  triggerPreState: (stateName) ->
    triggeredState = _.find @states, (state) =>
      return state.name == stateName
    if _.isFunction(triggeredState.pre)
      triggeredState.pre()

  triggerPostState: (stateName) ->
    triggeredState = _.find @states, (state) =>
      return state.name == stateName
    if _.isFunction(triggeredState.post)
      triggeredState.post()

  triggerPreStateRemove: (stateName) ->
    triggeredState = _.find @states, (state) =>
      return state.name == stateName
    if _.isFunction(triggeredState.preRemove)
      triggeredState.preRemove()

  triggerPostStateRemove: (stateName) ->
    triggeredState = _.find @states, (state) =>
      return state.name == stateName
    if _.isFunction(triggeredState.postRemove)
      triggeredState.postRemove()










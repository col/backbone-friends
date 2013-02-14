@Friend = Backbone.Model.extend
  defaults:
    uid: null,
    name: null,
    picture: null


@Friends = Backbone.Collection.extend
  model: Friend
  initialize: (options)->
    this.session = options.session
  sync: (method, model, options) ->
    return unless this.session.isConnected()
    FB.api "/me/friends?access_token=#{this.session.get('accessToken')}", (response) ->
      if options.success
        options.success(model, response.data, options)


@FacebookSession = Backbone.Model.extend

  initialize: ->
    _.bindAll(this, 'onLoginStatusChange')
    FB.Event.subscribe('auth.authResponseChange', this.onLoginStatusChange)

  login: (callback) ->
    console.log 'login'
    if (typeof callback == 'undefined')
      callback = ->
    FB.login(callback)

  logout: ->
    console.log 'logout'
    FB.logout()

  updateLoginStatus: ->
    FB.getLoginStatus(this.onLoginStatusChange)

  onLoginStatusChange: (response) ->
    return false if this.get('loginStatus') == response.status

    accessToken = if response.authResponse then response.authResponse.accessToken else null
    this.set('accessToken', accessToken)
    console.log 'Access Token changed to: ' + this.get('accessToken')

    this.set('loginStatus', response.status)
    console.log 'Login status changed to: ' + this.get('loginStatus')

  isConnected: ->
    return this.get('loginStatus') == 'connected'
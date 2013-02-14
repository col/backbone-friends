FriendsApp.Models.Friend = Backbone.Model.extend
  defaults:
    uid: null,
    name: null,
    picture: null

  picture_url: ->
    pic = this.get('picture')
    if pic then pic.data.url else ''

  toggleSelected: ->
    value = if this.get('selected') then !this.get('selected') else true
    this.set('selected', value)


FriendsApp.Collections.Friends = Backbone.Collection.extend
  model: FriendsApp.Models.Friend

  initialize: (options)->
    this.session = options.session

  sync: (method, model, options) ->
    return unless this.session.isConnected()
    FB.api "/me/friends?fields=name,picture&access_token=#{this.session.get('accessToken')}", (response) ->
      if options.success
        options.success(model, response.data, options)

FriendsApp.Models.FacebookSession = Backbone.Model.extend
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
    this.set('loginStatus', response.status)

    event = if response.status == 'connected' then 'facebook:connected' else 'facebook:disconnected'
    this.trigger(event, this, response)

  isConnected: ->
    return this.get('loginStatus') == 'connected'
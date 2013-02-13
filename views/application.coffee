jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true

window.fbAsyncInit = ->
  FB.init(appId: '187652384691875', channelUrl: '//backbone-friends.local/channel.html')

  facebook_session = new FacebookSession()
  facebook_session.updateLoginStatus()

  $('.fb-login').click (e) ->
    e.preventDefault()
    facebook_session.login()

  $('.fb-logout').click (e) ->
    e.preventDefault()
    facebook_session.logout()

FacebookSession = Backbone.Model.extend
  _loginStatus: null

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
    console.log 'Login status changed to: '+ response.status
    return false if this._loginStatus == response.status
    this._loginStatus = response.status

  isConnected: ->
    return this._loginStatus == 'connected'
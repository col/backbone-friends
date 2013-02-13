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

  new LoginStatusView( el: $('#login-status'), model: facebook_session )

FacebookSession = Backbone.Model.extend

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
    this.set('loginStatus', response.status)

  isConnected: ->
    return this.get('loginStatus') == 'connected'

LoginStatusView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.model.bind 'change', this.render
    this.render()

  events:
    'click .fb-login': 'login',
    'click .fb-logout': 'logout'

  login: ->
    this.model.login()

  logout: ->
    this.model.logout()

  render: ->
    template_el = if this.model.isConnected() then $('#logged-out-template') else $('#logged-in-template')
    $(this.el).html(_.template(template_el.html())({}))
    this
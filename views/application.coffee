jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true

window.fbAsyncInit = ->
  FB.init(appId: '187652384691875', channelUrl: '//backbone-friends.local/channel.html')
  window.app = new AppView()

AppView = Backbone.View.extend
  el: $('#backbone-friends-app')
  initialize: ->
    this.session = new FacebookSession()
    this.friends = new Friends(session: this.session)
    new LoginStatusView(el: $('#login-status'), model: this.session)
    _.bindAll(this, 'render', 'loadFriends', 'addFriend', 'addAll')
    this.friends.bind 'add', this.addFriend
    this.friends.bind 'refresh', this.addAll
    this.session.bind 'change:loginStatus', this.loadFriends
    this.session.updateLoginStatus()

  loadFriends: ->
    this.friends.fetch(silent: false)

  addFriend: (friend) ->
    console.log 'addFriend here...'
    console.log friend

  addAll:  ->
    console.log 'addAll here...'

  render: ->
    console.log 'app render - not yet implemented'

#FriendView = Backbone.View.extend
#  className: 'friend'
#  tagName: 'li'
#  initialize: ->
#    this.template = _.template($('#friend-template').html())
#    _.bindAll(this, 'render')
#  render: ->
#    $(this.el).html(this.template(this.model.toJSON()))
#    this

LoginStatusView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.model.bind 'change:loginStatus', this.render
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
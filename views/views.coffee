FriendsApp.Views.FriendsIndex = Backbone.View.extend
  id: 'friends-list'

  initialize: ->
    _.bindAll(this, 'render')
    this.template = _.template($('#friends-template').html())
    this.collection.bind 'reset', this.render

  render: ->
    self = this
    $(this.el).html(this.template())
    this.collection.each (friend) ->
      friendView = new FriendsApp.Views.FriendView(model: friend)
      self.$('ul').append(friendView.render().el)
    this


FriendsApp.Views.FriendView = Backbone.View.extend
  tagName: 'li'

  initialize: ->
    _.bindAll this, 'render'
    this.template = _.template($('#friend-template').html())
    this.model.bind 'change', this.render

  events:
    'click': 'clicked'

  clicked: ->
    this.model.toggleSelected()

  render: ->
    $(this.el).html(this.template(friend: this.model))
    this


FriendsApp.Views.LoginStatusView = Backbone.View.extend
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
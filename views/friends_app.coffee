@FriendsApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new FriendsApp.Routers.Friends()
    Backbone.history.start()

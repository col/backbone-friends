@FriendsApp =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    session = new FriendsApp.Models.FacebookSession()
    friends = new FriendsApp.Collections.Friends(session: session)
    new FriendsApp.Views.FriendsIndex(collection: friends, el: $('#friends-list'))
    new FriendsApp.Views.LoginStatusView(model: session, el: $('#login-status'))

    session.on 'facebook:connected', (session, response) ->
      friends.fetch(silent: false)
      $('#friends-list').show()

    session.on 'facebook:disconnected', (session, response) ->
      $('#friends-list').hide()

    session.updateLoginStatus()

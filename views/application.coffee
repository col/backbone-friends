jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true

window.fbAsyncInit = ->
  FB.init(appId: '187652384691875', channelUrl: '//backbone-friends.local/channel.html')
  FriendsApp.initialize()
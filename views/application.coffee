jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true

  $('.fb-login').click (e) ->
    e.preventDefault()
    console.log 'Logging in...'
    FB.login (response) ->
      if response.authResponse
        window.loggedIn()
      else
        console.log 'User cancelled login or did not fully authorize.'

window.loggedIn = ->
  FB.api '/me', (response) ->
    $('.login-status').html('Welcome to backbone-friends, ' + response.name + '.')

window.fbAsyncInit = ->
  FB.init(appId: '187652384691875', channelUrl: '//backbone-friends.local/channel.html',
          cookie: true, status: true, xfbml: true, frictionlessRequests: true)

  FB.getLoginStatus (response) ->
    console.log 'Login Status: ' + response.status
    if response.status == 'connected'
      window.loggedIn()
$ = require('jquery')

PREFIX = "http://localhost:3000"

module.exports =
  getAuthorizationUrl: (callback) ->
    $.get "#{PREFIX}/authorization_url",
      '',
      callback,
      'json'

  getToken: (callback) ->
    $.get "#{PREFIX}/token",
      '',
      callback,
      'json'

  getUsername: (callback) ->
    $.get "#{PREFIX}/username",
      '',
      callback,
      'json'

  getSubscriptions: (callback) ->
    $.get "#{PREFIX}/subscriptions",
      '',
      callback,
      'json'

  updateSubscriptions: (subscriptions) ->
    $.get "#{PREFIX}/update_subscriptions",
      {subscriptions: JSON.stringify(subscriptions)},
      (->),
      'json'

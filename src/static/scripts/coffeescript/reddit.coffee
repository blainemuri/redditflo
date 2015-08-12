React = require('react')
$ = require('jquery')

module.exports =
  getUserComments: (userName, parameters, callback) ->
    $.get "https://reddit.com/user/#{userName}/comments.json",
      parameters
      (data) -> callback data.data.children
      'json'

  getUserSubmissions: (userName, parameters, callback) ->
    $.get "https://reddit.com/user/#{userName}/submitted.json",
      parameters
      (data) -> callback data.data.children
      'json'

  getSubredditComments: (subreddit, parameters, callback) ->
    $.get "https://reddit.com/r/#{subreddit}.json",
      parameters
      (data) -> callback data.data.children

  getSubredditSubmissions: (subreddit, parameters, callback) ->
    $.get "https://reddit.com/r/#{subreddit}.json",
      parameters
      (data) -> callback data.data.children
      'json'

  getUser: (username, parameters, callback) ->
    $.get("https://reddit.com/u/#{username}.json", parameters, 'json')
      .done (data) =>
        callback data.data
      .fail (error) ->
        callback 'USERNAME ERROR'

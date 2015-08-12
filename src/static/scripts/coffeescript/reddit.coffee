React = require('react')
$ = require('jquery')

module.exports =
  getUserSubmissions: (userName, parameters, callback) ->
    $.get "https://reddit.com/user/#{userName}/submitted.json",
      parameters
      (data) -> callback data.data.children
      'json'

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
        callback 'RETRIEVAL ERROR'

  getSubreddit: (subreddit, parameters, callback) ->
    $.get("https://reddit.com/r/#{subreddit}.json", parameters, 'json')
      .done (data) =>
        callback data.data.children
      .fail (error) ->
        callback 'RETRIEVAL ERROR'

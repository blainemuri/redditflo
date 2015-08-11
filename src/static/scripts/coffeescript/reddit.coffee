$ = require('jquery')

module.exports =
  getUserSubmissions: (userName, parameters, callback) ->
    $.get "https://reddit.com/user/#{userName}/submitted.json",
      parameters
      (data) -> callback data.data.children
      'json'

  getSubredditSubmissions: (subreddit, parameters, callback) ->
    $.get "https://reddit.com/r/#{subreddit}.json",
      parameters,
      (data) -> callback data.data.children
      'json'

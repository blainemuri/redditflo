PREFIX = 'https://www.reddit.com'

redditRequest = (url, data, callback) ->
  response = $.getJSON "#{PREFIX}#{url}/.json", data, callback

window['redditRequest'] = redditRequest

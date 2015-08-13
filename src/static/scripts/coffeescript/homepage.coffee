React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Feed} = require('redditflo/feed')
Python = require('redditflo/python')

Homepage = React.createClass
  render: ->
    {div, img, span, webview} = React.DOM
    feed = @props.feed
    div className: 'container',
      feed.map (data) =>
        span key: data.data.name,
          React.createElement Feed,
            data: data
            onUrl: @props.onUrl

module.exports =
  Homepage: Homepage

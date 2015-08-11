React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Feed} = require('redditflo/feed')
Python = require('redditflo/python')

Homepage = React.createClass
  render: ->
    {div, img, span} = React.DOM
    feed = @props.feed
    div className: 'container',
      feed.map (data, idx) -> React.createElement(Feed, data: data)

module.exports =
  Homepage: Homepage

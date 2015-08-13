React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Feed} = require('redditflo/feed')
Python = require('redditflo/python')

Homepage = React.createClass
  getInitialState: ->
    start: 0

  onClickPrevious: ->
    start = Math.min @props.feed.length, Math.max 0, @state.start-@props.nShown
    @setState start: start
    window.scroll(window.scrollX, 0)

  onClickNext: ->
    start = Math.min @props.feed.length, Math.max 0, @state.start+@props.nShown
    @setState start: start
    window.scroll(window.scrollX, 0)

  renderNavigation: ->
    {div, span} = React.DOM
    span {},
      div
        onClick: @onClickPrevious
        style:
          float: 'left'
        'Previous'
      div
        onClick: @onClickNext
        style:
          float: 'right'
        'Next'

  render: ->
    {div, img, span, webview} = React.DOM
    feed = @props.feed
    start = @state.start
    end = start + @props.nShown
    div className: 'container',
      feed.slice(start, end).map (data) =>
        span key: data.data.name,
          React.createElement Feed,
            data: data
            onUrl: @props.onUrl
      @renderNavigation()
module.exports =
  Homepage: Homepage

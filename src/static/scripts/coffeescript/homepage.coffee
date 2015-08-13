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
    {button, div, img, span, webview} = React.DOM
    feed = @props.feed
    start = @state.start
    end = start + @props.nShown
    div className: 'container',
      div className: 'sort-buttons',
          span className: 'sort-by', 'Sort By:'
          button className: 'sort-button', 'time'
          button className: 'sort-button', 'score'
          button className: 'sort-button', 'ups'
          button className: 'sort-button', 'downs'
      feed.slice(start, end).map (data) =>
        span key: data.data.name,
          React.createElement Feed,
            data: data
            onUrl: @props.onUrl
      if feed.length > 0
        @renderNavigation()
module.exports =
  Homepage: Homepage

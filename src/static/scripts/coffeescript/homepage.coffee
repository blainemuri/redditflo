React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Feed} = require('redditflo/feed')
Python = require('redditflo/python')
{Loading} = require('redditflo/loading')

Homepage = React.createClass
  getInitialState: ->
    start: 0
    loading: yes

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

  handleSort: (sort) ->
    @props.setSort sort

  notLoading: ->
    console.log "in not loading"
    @setState loading: no

  render: ->
    {button, div, img, span, webview} = React.DOM
    feed = @props.feed
    start = @state.start
    end = start + @props.nShown
    div {},
      if @state.loading
        React.createElement(Loading, {})
      div className: 'container',
        div className: 'sort-buttons',
            span className: 'sort-by', 'Sort By:'
            button
              className: "sort-button #{'focus' if @props.focus is 'created_utc'}"
              onClick: => @handleSort 'created_utc'
              'time'
            button
              className:  "sort-button #{'focus' if @props.focus is 'score'}"
              onClick: => @handleSort 'score'
              'score'
            button
              className: "sort-button #{'focus' if @props.focus is 'ups'}"
              onClick: => @handleSort 'ups'
              'ups'
            button
              className: "sort-button #{'focus' if @props.focus is 'downs'}"
              onClick: => @handleSort 'downs'
              'downs'
            button
              className: "sort-button #{'focus' if @props.focus is 'author'}"
              onClick: => @handleSort 'author'
              'author'
        feed.slice(start, end).map (data) =>
          span key: data.data.name,
            React.createElement Feed,
              data: data
              notLoading: @notLoading
        if feed.length > 0
          @renderNavigation()

module.exports =
  Homepage: Homepage

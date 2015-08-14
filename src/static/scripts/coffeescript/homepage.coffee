React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Feed} = require('redditflo/feed')
Python = require('redditflo/python')
{Loading} = require('redditflo/loading')

User = React.createClass
  render: ->
    {div} = React.DOM
    div className: 'user-sort-item', 'User'

Homepage = React.createClass
  getInitialState: ->
    start: 0
    loading: yes
    users: no

  onClickPrevious: ->
    start = Math.max 0, @state.start-@props.nShown
    @setState start: start
    window.scroll(window.scrollX, 0)

  onClickNext: ->
    start = Math.min @props.feed.length-@props.nShown, @state.start+@props.nShown
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

  notLoading: -> @setState loading: no

  handleUserSort: (e) ->
    e.stopPropagation()
    @setState users: not @state.users
    @handleSort 'author'

  hide: -> @setState users: no

  render: ->
    {button, div, img, span, webview, input} = React.DOM
    feed = @props.feed
    start = @state.start
    end = start + @props.nShown
    div {},
      if @state.loading
        React.createElement(Loading, {})
      div
        className: 'container'
        onClick: => @hide()
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
              onClick: (e) => @handleUserSort e
              'author'
        if @state.users
          div
            className: 'user-sort'
            onClick: (e) => e.stopPropagation()
            div className: 'static-items',
              div className: 'user-sort-item', 'All'
              input
                className: 'user-sort-input'
                placeholder: 'Search'
            div className: 'dynamic-items',
              React.createElement(User, {})
              React.createElement(User, {})
              React.createElement(User, {})
              React.createElement(User, {})
              React.createElement(User, {})
              React.createElement(User, {})
        feed.slice(start, end).map (data) =>
          span key: data.data.name,
            React.createElement Feed,
              data: data
              notLoading: @notLoading
        if feed.length > 0
          @renderNavigation()

module.exports =
  Homepage: Homepage

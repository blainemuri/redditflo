React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Homepage} = require('redditflo/homepage')
{Login} = require('redditflo/login')
Python = require('redditflo/python')

App = React.createClass
  getInitialState: ->
    currentPage: 'homepage'
    feeds: {}
    mainFeed: []
    profile: {}
    token: ''
    username: ''

  componentDidMount: ->
    setInterval @onInterval, 2000

  onInterval: ->
    if @state.token is ''
      Python.getToken (data) => @setState token: data.token
      Python.getUsername (data) => @setState username: data.username
    else
      ''

  fetchFeeds: ->
    subscriptions = @profile.subscriptions
    subscriptions.forEach sub =>
      fetcher = if sub.type is 'user' then reddit.getUserSubmissions else reddit.getSubredditSubmissions
      fetcher sub.name, {}, (data) =>
        feeds = @state.feeds
        feeds[sub.name] = data
        @setState feeds: feeds

  reloadMainFeed: ->
    keys = Object.keys @sate.feeds
    values = keys.map (k) => @state.feeds[k]
    values = _.sortBy values, (v) -> v.data.created_utc
    @setState mainFeed: values

  render: ->
    if @state.token is ''
      React.createElement(Login, login: @setToken)
    else if @state.currentPage is 'homepage'
      React.createElement(Homepage, feed: @state.mainFeed)
    else
      '404'

React.render(
  React.createElement(App, null), document.getElementById('main')
)

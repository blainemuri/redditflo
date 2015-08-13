React = require('react')
_ = require('underscore')

reddit = require('redditflo/reddit')
Python = require('redditflo/python')

{Login} = require('redditflo/login')
{Navbar} = require('redditflo/navbar')
{Homepage} = require('redditflo/homepage')
{Subscriptions} = require('redditflo/subscriptions')
{Profile} = require('redditflo/profile')
{Logout} = require('redditflo/logout')
windows = require('redditflo/windows')

DEFAULT_STATE =
  currentPage: 'homepage'
  feeds: {}
  mainFeed: []
  intervalIds:
    login: 0
  settings:
    autoRefreshBatchSize: 4
    autoRefreshEnabled: yes
    enableAccountUpdates: no
    limit: 100
    shownFeedSize: 50
    sortBy: 'ups' # 'author', 'created_utc', 'score', 'ups', 'downs', #note: downs doesn't work
    sortOrder: -1 # 1: ascending, -1 descending
  subscriptions: []
  token: ''
  username: ''

App = React.createClass
  getInitialState: ->
    DEFAULT_STATE

  componentDidMount: ->
    loginIntervalId = setInterval @onIntervalLogin, 1000
    setTimeout @onIntervalUpdateFeed, @state.refreshTime
    @setState intervalIds:
      login: loginIntervalId

  onIntervalLogin: ->
    currentToken = @state.token
    Python.getToken (data) =>
      @setState token: data.token
      if currentToken isnt '' and data.token is ''
        @logout()
    if currentToken is ''
      Python.getUsername (data) => @setState username: data.username
      Python.getSubscriptions (data) =>
        if data.subscriptions?
          @setSubscriptions data.subscriptions

  onIntervalUpdateFeed: ->
    if @state.settings.autoRefreshEnabled
      subs = _.sortBy Object.keys(@state.feeds), (f) => @state.feeds[f].updated
      lastUpdated = if subs.length is 0 then 0 else @state.feeds[subs[0]].updated
      subs = subs.slice(0, @state.settings.autoRefreshBatchSize)
      subs = subs.map (key) => @state.feeds[key]
      @fetchFeeds subs
      @reloadMainFeed()
    setTimeout @onIntervalUpdateFeed, if lastUpdated is 0 then 2000 else 5000

  setSubscriptions: (subscriptions) ->
    if @state.settings.enableAccountUpdates
      Python.updateSubscriptions subscriptions
    @setState
      subscriptions: subscriptions
      feeds: _.object subscriptions.map (sub) ->
        key = "#{sub.name}_#{sub.type}"
        value =
          feed: []
          name: sub.name
          type: sub.type
          updated: 0
        [key, value]

  fetchFeeds: (subscriptions) ->
    subscriptions.forEach (sub) =>
      if sub.type is 'user'
        reddit.getUserSubmissions sub.name, {limit: @state.settings.limit}, (data) =>
          key = "#{sub.name}_#{sub.type}"
          feeds = @state.feeds
          feed = feeds[key]
          feed.feed = data
          feed.feed.forEach (entry) -> entry.type = sub.type
          feed.updated = Date.now()
          feeds[key] = feed
          @setState feeds: feeds
      else if sub.type is 'subreddit'
        reddit.getSubredditSubmissions sub.name, {limit: @state.settings.limit}, (data) =>
          key = "#{sub.name}_#{sub.type}"
          feeds = @state.feeds
          feed = feeds[key]
          feed.feed = data
          feed.feed.forEach (entry) -> entry.type = sub.type
          feed.updated = Date.now()
          feeds[key] = feed
          @setState feeds: feeds

  reloadMainFeed: ->
    keys = Object.keys @state.feeds
    feeds = keys.map (k) => @state.feeds[k].feed
    feeds = _.flatten feeds, true
    feeds = _.sortBy feeds, (f) => @state.settings.sortOrder * f.data[@state.settings.sortBy]
    @setState mainFeed: feeds

  logout: ->
    Python.resetToken()
    @setState DEFAULT_STATE

  render: ->
    {div} = React.DOM
    if @state.token is ''
      React.createElement(Login, login: @setToken)
    else
      div {},
        React.createElement Navbar,
          username: @state.username
          setCurrentPage: (page) => @setState currentPage: page
        if @state.currentPage is 'homepage'
          React.createElement Homepage,
            feed: @state.mainFeed
            nShown: @state.settings.shownFeedSize
            onUrl: (url) -> windows.setReddit url
        else if @state.currentPage is 'subscriptions'
          React.createElement(Subscriptions, setSubscriptions: @setSubscriptions, sub: @state.subscriptions)
        else if @state.currentPage is 'profile'
          React.createElement(Profile, setSubs: @setSubscriptions, username: @state.username, subscriptions: @state.subscriptions)
        else if @state.currentPage is 'logout'
          React.createElement(Logout, logout: @logout)
        else
          '404'

React.render(
  React.createElement(App, null), document.getElementById('main')
)

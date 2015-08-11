React = require('react')
reddit = require('redditflo/reddit')
_ = require('underscore')
{Login} = require('redditflo/login')
Python = require('redditflo/python')

{Navbar} = require('redditflo/navbar')
{Homepage} = require('redditflo/homepage')
{Subscriptions} = require('redditflo/subscriptions')
{Profile} = require('redditflo/profile')
{Logout} = require('redditflo/logout')

App = React.createClass
  getInitialState: ->
    currentPage: 'homepage'
    feeds: {}
    mainFeed: []
    setIntervalID: 0
    settings:
      autoRefreshBatchSize: 1
      autoRefreshEnabled: yes
      enableAccountUpdates: no
    subscriptions: {}
    token: ''
    username: ''

  componentDidMount: ->
    @setState setIntervalID: setInterval @onInterval, 2000

  onInterval: ->
    if @state.token is ''
      Python.getToken (data) => @setState token: data.token
      Python.getUsername (data) => @setState username: data.username
      Python.getSubscriptions (data) => @setSubscriptions data.subscriptions
    else
      if @state.settings.autoRefreshEnabled
        subs = _.sortBy Object.keys(@state.feeds), (f) => @state.feeds[f].updated
        subs = subs.slice(0, @state.settings.autoRefreshBatchSize)
        subs = subs.map (key) => @state.feeds[key]
        @fetchFeeds subs
        @reloadMainFeed()

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
          updated: Date.now()
        [key, value]

  fetchFeeds: (subscriptions) ->
    subscriptions.forEach (sub) =>
      fetcher = if sub.type is 'user' then reddit.getUserSubmissions else reddit.getSubredditSubmissions
      fetcher sub.name, {}, (data) =>
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
    feeds = _.sortBy feeds, (f) -> -f.data.created_utc
    @setState mainFeed: feeds

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
          React.createElement(Homepage, feed: @state.mainFeed)
        else if @state.currentPage is 'subscriptions'
          React.createElement(Subscriptions, setSubscriptions: @setSubscriptions, sub: @state.subscriptions)
        else if @state.currentPage is 'profile'
          React.createElement(Profile, {})
        else if @state.currentPage is 'logout'
          React.createElement(Logout, {})
        else
          '404'

React.render(
  React.createElement(App, null), document.getElementById('main')
)

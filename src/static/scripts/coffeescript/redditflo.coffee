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
    updateFeed: 0
  settings:
    autoRefreshBatchSize: 4
    autoRefreshEnabled: yes
    enableAccountUpdates: no
    limit: 10
    shownFeedSize: 50
    sortBy: 'score' # 'author', 'created_utc', 'score', 'ups', 'downs', #note: downs doesn't work
    sortAscending: no
  subscriptions: []
  token: ''
  username: ''

loginTick = 0
updateFeedTick = 0

App = React.createClass
  getInitialState: ->
    DEFAULT_STATE

  componentDidMount: ->
    loginIntervalId = setInterval @onIntervalLogin, 1000
    updateFeedId = setInterval @onIntervalUpdateFeed, 2000
    @setState intervalIds:
      login: loginIntervalId
      updateFeed: updateFeedId

  setSortingMethod: (sort, ascending=false) ->
    settings = @state.settings
    settings.sortBy = sort
    settings.ascending = ascending
    @setState
      settings: settings
      mainFeed: @getSortedFeed @state.mainFeed, settings

  getSortedFeed: (feed, settings) ->
    settings = if settings? then settings else @state.settings
    feed = _.sortBy feed, (el) => el.data[settings.sortBy]
    if settings.sortAscending then feed else feed.reverse()

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
    loginTick += 1

  onIntervalUpdateFeed: ->
    feeds = @state.feeds
    if @state.settings.autoRefreshEnabled and Object.keys(feeds).length > 0
      lastUpdated = (_.min feeds, (feed) -> feed.updated).updated
      if (lastUpdated is 0) or (updateFeedTick%10 is 0)
        subs = _.sortBy feeds, 'updated'
          .slice 0, @state.settings.autoRefreshBatchSize
        @fetchFeeds subs
    updateFeedTick += 1

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
          setTimeout @reloadMainFeed, 500
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
          setTimeout @reloadMainFeed, 500

  reloadMainFeed: ->
    keys = Object.keys @state.feeds
    feeds = keys.map (k) => @state.feeds[k].feed
    feeds = _.flatten feeds, true
    @setState mainFeed: @getSortedFeed feeds

  logout: ->
    Python.resetToken()
    @setState DEFAULT_STATE

  render: ->
    {div, button, span} = React.DOM
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
            setSort: @setSortingMethod
            focus: @state.settings.sortBy
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

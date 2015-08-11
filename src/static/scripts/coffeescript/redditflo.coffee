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
    subscriptions: {}
    token: ''
    username: ''

  componentDidMount: ->
    setInterval @onInterval, 2000

  onInterval: ->
    if @state.token is ''
      Python.getToken (data) => @setState token: data.token
      Python.getUsername (data) => @setState username: data.username
      Python.getSubscriptions (data) => @setState subscriptions: data.subscriptions
    else
      null

  fetchFeeds: ->
    subscriptions = @state.subscriptions
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
          React.createElement(Subscriptions, {})
        else if @state.currentPage is 'profile'
          console.log "current state is profile"
          React.createElement(Profile, {})
        else if @state.currentPage is 'logout'
          React.createElement(Logout, {})
        else
          '404'

React.render(
  React.createElement(App, null), document.getElementById('main')
)

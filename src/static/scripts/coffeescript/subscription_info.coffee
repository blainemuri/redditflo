React = require('react')
_ = require('underscore')

reddit = require('redditflo/reddit')

SubscriptionInfo = React.createClass
  getInitialState: ->
    participations: []

  componentDidMount: ->
    if @props.type is 'user'
      reddit.getUser @props.name, limit: 100, (data) =>
        participations = if data.children? then data.children else []
        @setState participations: _.sortBy (participations.map (x) -> x.data), (x) -> -x.score

  getSubredditCounts: ->
    participations = @state.participations
    subredditCounts = participations.reduce ((a, b) -> b = b.subreddit; a[b] = (a[b] or 0) + 1; a), {}
    subredditCounts = Object.keys(subredditCounts).map (k) -> [k, subredditCounts[k]]
    subredditCounts = _.sortBy subredditCounts, ([k, v]) -> -v
    subredditCounts

  getStats: ->
    if @props.type is 'user'
      @getSubredditCounts().slice(0, 3).map ([key, value]) -> "#{key}: #{value}"
    else
      []

  render: ->
    {div} = React.DOM
    stats = @getStats()
    div key: "#{@props.name}-#{@props.type}",
      stats.map (x) -> div {}, x

module.exports =
  SubscriptionInfo: SubscriptionInfo

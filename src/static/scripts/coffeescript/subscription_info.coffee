React = require('react')
_ = require('underscore')

NO_SHOW = 0
DONE = 1

reddit = require('redditflo/reddit')

SubscriptionInfo = React.createClass
  getInitialState: ->
    participations: []
    show: NO_SHOW

  componentDidMount: ->
    @loadInfo @props.name, @props.type

  componentWillReceiveProps: (nextProps) ->
    if @props.name isnt nextProps.name or @props.type isnt nextProps.type
      @setState participations: []
      @loadInfo nextProps.name, nextProps.type
    setTimeout (=> @setState show: DONE), 1000

  loadInfo: (name, type) ->
    fetcher = if type is 'user' then reddit.getUser else reddit.getSubreddit
    fetcher name, limit: 100, (data) =>
      participations = if data.children? then data.children else []
      @setState participations: _.sortBy (participations.map (x) -> x.data), (x) -> -x.score

  renderActiveSubreddits: ->
    participations = @state.participations
    return '' unless participations.length > 0
    subredditCounts = participations.reduce ((a, b) -> b = b.subreddit; a[b] = (a[b] or 0) + 1; a), {}
    subredditCounts = Object.keys(subredditCounts).map (k) -> [k, subredditCounts[k]]
    subredditCounts = _.sortBy subredditCounts, ([k, v]) -> -v
    subredditCounts = subredditCounts.slice(0, 3)
    subredditCounts = subredditCounts.map ([key, value]) -> key
    React.DOM.div className: "subscription-info-section-#{@props.type} title-text",
      "Active On: #{subredditCounts.join(', ')}"

  render: ->
    {div, img} = React.DOM
    div {},
      if @state.show is DONE
        div className: 'subscription-info', key: "#{@props.name}-#{@props.type}",
          @renderActiveSubreddits()
          if @state.participations.length > 0
            @state.participations.slice(0, 3).map (p) =>
              type = if p.name.slice(0, 2) is 't1' then 'comment' else 'post'
              title = if p.title? then p.title else p.link_title
              content = if type is 'comment' then p.body else p.selftext
              div className: "subscription-info-section-#{@props.type}",
                div className: 'title-text', title
                div className: 'body-text', content
          else
            div className: 'subscription-info-section',
              div className: 'title-text', 'No Content!'
              div className: 'body-text', "User doesn't seem to be active :/"
      else
        div className: 'loading-subscription',
          img
            className: 'loading-small'
            src: 'images/loading.gif'

module.exports =
  SubscriptionInfo: SubscriptionInfo

React = require('react')
$ = require('jquery')
Dropzone = require('dropzone')
reddit = require('redditflo/reddit')
_ = require('underscore')

Uploader = React.createClass
  getInitialState: ->
    src: "images/#{@props.username}.jpg"

  componentDidMount: ->
    Dropzone.autoDiscover = no
    myDropzone = new Dropzone(@getDOMNode(), {url: '/file/upload'})
    img = new Image()
    img.onerror = (=>
      @setState src: 'images/blank-user.png')
    img.src = @state.src

  render: ->
    {div, form, img} = React.DOM
    div {},
      form
        action: '/file/upload'
        className: 'dropzone'
        id: 'dropzone'
        div className: 'dz-default dz-message text-center',
          img
            className: 'dropzone-inner'
            src: "#{@state.src}"

SubscriptionInfo = React.createClass
  getInitialState: ->
    submissions: []
    comments: []

  getParticipation: ->
    participations = @state.submissions.concat @state.comments
    subredditCounts = participations.reduce ((a, b) -> b = b.subreddit; a[b] = (a[b] or 0) + 1; a), {}
    subredditCounts = Object.keys(subredditCounts).map (k) -> [k, subredditCounts[k]]
    subredditCounts = _.sortBy subredditCounts, ([k, v]) -> -v
    subredditCounts.map ([key, value]) -> "#{key}: #{value}"
      .slice(0, 3)

  getStats: ->
    if @props.type is 'user'
      @getParticipation()
    else
      []

  componentDidMount: ->
    if @props.type is 'user'
      reddit.getUserComments @props.name, limit: 50, (data) =>
        @setState comments: data.map (x) -> x.data
      reddit.getUserSubmissions @props.name, limit: 50, (data) =>
        @setState submissions: data.map (x) -> x.data

  render: ->
    {div} = React.DOM
    div key: "#{@props.name}-#{@props.type}",
      @getStats().map (x) -> div {}, x

Subscription = React.createClass
  getInitialState: ->
    showInfo: no

  deleteSubscription: ->
    newSubs = []
    @props.subs.map (sub) =>
      if sub.name isnt @props.name or sub.type isnt @props.type then newSubs.push sub
    @props.setSubs newSubs

  toggleShowInfo: ->
    @setState showInfo: not @state.showInfo

  render: ->
    {div, img} = React.DOM
    div {},
      div className: 'subscription-container',
        div className: 'sub-name', onClick: @toggleShowInfo, "@#{@props.name}"
        div
          className: 'sub-x'
          onClick: => @deleteSubscription()
          img
            className: 'cancel-icon'
            src: 'images/cancel.png'
      if @state.showInfo
        React.createElement SubscriptionInfo,
          name: @props.name
          type: @props.type

MainContent = React.createClass
  render: ->
    {div, span} = React.DOM
    div {},
      div className: 'profile-card follow',
        div className: 'follow-card card-blue',
          div className: 'profile-title', 'Following'
          span className: 'underline card-blue',''
          div className: 'profile-card-inner',
            @props.subscriptions.map (sub) =>
              if sub.type is 'user'
                React.createElement Subscription,
                  type: 'user'
                  name: sub.name
                  setSubs: @props.setSubs
                  subs: @props.subscriptions
      div className: 'profile-card subreddit',
        div className: 'subreddit-card card-orange',
          div className: 'profile-title', 'Subreddits'
          span className: 'underline card-orange', ''
          div className: 'profile-card-inner',
            @props.subscriptions.map (sub) =>
              if sub.type is 'subreddit'
                React.createElement Subscription,
                  type: 'subreddit'
                  name: sub.name
                  setSubs: @props.setSubs
                  subs: @props.subscriptions

Content = React.createClass
  numFollowing: ->
    total = 0
    @props.subscriptions.map (sub) ->
      if sub.type is 'user' then total+=1
    return total

  render: ->
    {div, form, img} = React.DOM
    div className: 'container',
      React.createElement(Uploader, {})
      div className: 'profile-info',
        div className: 'username', "@#{@props.username}"
        div className: 'following', "Following: #{@numFollowing()} redditors"
      div className: 'profile-content',
        React.createElement MainContent,
          subscriptions: @props.subscriptions
          setSubs: @props.setSubs

module.exports =
  Profile: Content

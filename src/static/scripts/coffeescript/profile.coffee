React = require('react')
$ = require('jquery')
Dropzone = require('dropzone')

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

Subscription = React.createClass
  getInitialState: ->
    name: @props.name
    type: @props.type

  render: ->
    {div, img} = React.DOM
    div {},
      div className: 'subscription-container',
        div className: 'sub-name', "@#{@props.name}"
        div className: 'sub-x',
          img
            className: 'cancel-icon'
            src: 'images/cancel.png'

MainContent = React.createClass
  getInitialState: ->
    subscriptions: @props.subscriptions

  render: ->
    {div, span} = React.DOM
    div {},
      div className: 'profile-card follow',
        div className: 'follow-card card-blue',
          div className: 'profile-title', 'Following'
          span className: 'underline card-blue',''
          div className: 'profile-card-inner',
            @props.subscriptions.map (sub) ->
              if sub.type is 'user'
                React.createElement(Subscription, type: 'user', name: sub.name)
      div className: 'profile-card subreddit',
        div className: 'subreddit-card card-orange',
          div className: 'profile-title', 'Subreddits'
          span className: 'underline card-orange', ''
          div className: 'profile-card-inner',
            @props.subscriptions.map (sub) ->
              if sub.type is 'subreddit'
                React.createElement(Subscription, type: 'subreddit', name: sub.name)

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
        React.createElement(MainContent, subscriptions: @props.subscriptions)

module.exports =
  Profile: Content
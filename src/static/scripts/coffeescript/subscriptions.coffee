React = require('react')
reddit = require('redditflo/reddit')

{SubscriptionInfo} = require('redditflo/subscription_info')

LIMIT = 1000

###########################################
# This whole class needs refactoring :/
###########################################

Content = React.createClass
  getInitialState: ->
    searchString: ''
    userData: ''
    user: ''
    userDataClass: ''
    subData: ''
    sub: ''
    subDataClass: ''
    searched: no

  handleChange: ->
    @setState searchString: event.target.value

  handleSubmit: (event) ->
    @setState searched: yes
    sub = @state.searchString
    user = @state.searchString
    @setState
      searched: yes
      subData: ''
      subDataClass: ''
      userData: ''
      userDataClass: ''
    reddit.getUser @state.searchString, {}, (data) =>
      user = @state.searchString
      setTimeout( =>
        if data is 'RETRIEVAL ERROR'
          @setState
            userData: ''
            userDataClass: 'user-error card-error'
        else if @newUser user
          @setState
            userData: "follow @#{user}"
            user: user
            userDataClass: 'user-info card-blue'
        else
          @setState
            userData: "following @#{user}"
            user: user
            userDataClass: 'user-info card-success'
      , 0)
    reddit.getSubreddit @state.searchString, {}, (data) =>
      setTimeout( =>
        if data is 'RETRIEVAL ERROR' or data.children.length is 0 or sub is ''
          @setState
           subData: ''
           subDataClass: 'user-error card-error'
        else if @newSub sub
          @setState
            subData: "follow /r/#{sub}"
            sub: sub
            subDataClass: 'user-info card-orange'
        else
          @setState
            subData: "following /r/#{sub}"
            sub: sub
            subDataClass: 'user-info card-success'
      , 0)

  submitUser: ->
    @props.sub.push { "name": "#{@state.user}", "type": "user" }
    @props.setSubscriptions @props.sub
    @setState
      userDataClass: 'user-info card-success'
      userData: "following @#{@state.user}"

  submitSub: ->
    @props.sub.push { "name": "#{@state.user}", "type": "subreddit" }
    @props.setSubscriptions @props.sub
    @setState
      subDataClass: 'user-info card-success'
      subData: "following /r/#{@state.user}"

  #Refactor these two together later
  newUser: (currUser) ->
    valid = true
    @props.sub.map (user) ->
      if user.type is "user" and user.name is currUser
        valid = false
    return valid

  newSub: (currSub) ->
    valid = true
    @props.sub.map (sub) ->
      if sub.type is 'subreddit' and sub.name is currSub
        valid = false
    return valid

  render: ->
    {div, input, button, form} = React.DOM
    div className: 'container',
      div className: 'search-box',
        div className: 'title', 'Follow users and subreddits'
        input
          className: 'search-text'
          type: 'text'
          onSubmit: @handleSubmit
          value: @state.searchString
          onChange: @handleChange
          placeholder: 'Search...'
          onKeyPress: (e) =>
            if e.key is 'Enter' then @handleSubmit e
        button
          className: 'search-submit'
          type: 'submit'
          onClick: @handleSubmit
          'Submit'
        if @state.userData isnt ''
          div
            className: "#{@state.userDataClass}"
            onClick: => @submitUser() if @newUser(@state.user)
            @state.userData
            React.createElement SubscriptionInfo,
              name: @state.user
              type: 'user'
        if @state.subData isnt ''
          div
            className: "#{@state.subDataClass}"
            onClick: => @submitSub() if @newSub(@state.user)
            @state.subData
            React.createElement SubscriptionInfo,
              name: @state.sub
              type: 'subreddit'
        if @state.userData is '' and @state.subData is '' and @state.searched
          div
            className: "#{@state.userDataClass}"
            'No user or subreddit found!'

module.exports =
  Subscriptions: Content

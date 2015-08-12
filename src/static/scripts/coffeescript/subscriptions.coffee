React = require('react')
reddit = require('redditflo/reddit')

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
    @setState subData: ''
    @setState subDataClass: ''
    @setState userData: ''
    @setState userDataClass: ''
    reddit.getUser @state.searchString, {}, (data) =>
      user = @state.searchString
      setTimeout( =>
        if data is 'RETRIEVAL ERROR'
          @setState userData: ''
          @setState userDataClass: 'user-error card-error'
        else if @newUser user
          @setState userData: "follow @#{user}"
          @setState user: user
          @setState userDataClass: 'user-info card-blue'
        else
          @setState userData: "following @#{user}"
          @setState user: user
          @setState userDataClass: 'user-info card-success'
      , 0)
    reddit.getSubreddit @state.searchString, {}, (data) =>
      setTimeout( =>
        if data is 'RETRIEVAL ERROR' or data.length is 0 or sub is ''
          @setState subData: ''
          @setState subDataClass: 'user-error card-error'
        else if @newSub sub
          @setState subData: "follow /r/#{sub}"
          @setState sub: sub
          @setState subDataClass: 'user-info card-orange'
        else
          @setState subData: "following /r/#{sub}"
          @setState sub: sub
          @setState subDataClass: 'user-info card-success'
      , 0)

  submitUser: ->
    @props.sub.push { "name": "#{@state.user}", "type": "user" }
    @props.setSubscriptions @props.sub
    @setState userDataClass: 'user-info card-success'
    @setState userData: "following @#{@state.user}"

  submitSub: ->
    @props.sub.push { "name": "#{@state.user}", "type": "subreddit" }
    @props.setSubscriptions @props.sub
    @setState subDataClass: 'user-info card-success'
    @setState subData: "following /r/#{@state.user}"

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
        if @state.subData isnt ''
          div
            className: "#{@state.subDataClass}"
            onClick: => @submitSub() if @newSub(@state.user)
            @state.subData
        if @state.userData is '' and @state.subData is '' and @state.searched
          div
            className: "#{@state.userDataClass}"
            'No user or subreddit found!'

module.exports =
  Subscriptions: Content
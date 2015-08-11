React = require('react')
reddit = require('redditflo/reddit')

LIMIT = 1000

Content = React.createClass
  getInitialState: ->
    searchString: ''
    data: ''
    user: ''
    dataClass: ''
    following: no

  handleChange: ->
    @setState searchString: event.target.value

  handleSubmit: (event) ->
    reddit.getUser @state.searchString, {}, (data) =>
      user = @state.searchString
      @setState data: ''
      @setState dataClass: ''
      setTimeout( =>
        if data is 'USERNAME ERROR'
          @setState data: "That username doesn't seem to exist"
          @setState dataClass: 'user-error card-error'
        else if @newUser user
          @setState data: "Follow @#{user}"
          @setState user: user
          @setState dataClass: 'user-info card-blue'
        else
          @setState data: "Following @#{user}"
          @setState user: user
          @setState dataClass: 'user-info card-success'
      , 0)

  submitUser: ->
    @props.sub.push { "name": "#{@state.user}", "type": "user" }
    @props.setSubscriptions @props.sub
    @setState dataClass: 'user-info card-success'
    @setState data: "Following @#{@state.user}"

  newUser: (currUser) ->
    valid = true
    @props.sub.map (user) ->
      if user.type is "user" and user.name is currUser
        valid = false
    return valid

  render: ->
    {div, input, button} = React.DOM
    div className: 'container',
      div className: 'search-box',
        div className: 'title', 'Follow reddit users'
        input
          className: 'search-text'
          type: 'text'
          value: @state.searchString
          onChange: @handleChange
          placeholder: 'Search users'
        button
          className: 'search-submit'
          type: 'submit'
          onClick: @handleSubmit
          'Submit'
        div 
          className: "#{@state.dataClass}"
          onClick: => @submitUser() if @newUser(@state.user)
          @state.data

module.exports =
  Subscriptions: Content
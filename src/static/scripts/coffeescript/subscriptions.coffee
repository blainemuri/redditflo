React = require('react')
reddit = require('redditflo/reddit')

LIMIT = 1000

Content = React.createClass
  getInitialState: ->
    searchString: ''
    data: ''
    user: ''
    dataClass: ''

  handleChange: ->
    @setState searchString: event.target.value

  handleSubmit: (event) ->
    reddit.getUser @state.searchString, {}, (data) =>
      user = @state.searchString
      if data isnt 'USERNAME ERROR'
        @setState data: "Follow @#{user}"
        @setState user: user
        @setState dataClass: 'user-info card-blue'
      else
        @setState data: "That username doesn't seem to exist"
        @setState dataClass: 'user-error card-error'

  submitUser: ->
    @props.sub.push { "name": "#{@state.user}", "type": "user" }
    @props.setSubscriptions @props.sub

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
          onClick: => @submitUser()
          @state.data

module.exports =
  Subscriptions: Content
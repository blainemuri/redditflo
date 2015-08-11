React = require('react')

LIMIT = 1000

Content = React.createClass
  getInitialState: ->
    searchString: ''

  handleChange: ->
    @setState searchString: event.target.value

  handleSubmit: (event) ->
    console.log "Do some stuff"
    #Do some stuff later
    ###cback = (data, status) =>
      if status is 'success'
        @setState userInfo: data
      else
        console.log status
    username = @state.searchString
    redditRequest "/user/#{username}", {limit:LIMIT}, cback###

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
        div id: 'user-info', @state.searchString

module.exports =
  Subscriptions: Content
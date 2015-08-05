LIMIT = 10

SearchBar = React.createClass
  getInitialState: ->
    searchString: ''
    userInfo: {}

  handleChange: (event) ->
    @setState searchString: event.target.value

  handleSubmit: (event) ->
    cback = (data, status) =>
      if status is 'success'
        @setState userInfo: data
      else
        console.log status
    username = @state.searchString
    redditRequest "/user/#{username}", {limit:LIMIT}, cback

  render: ->
    {button, div, input} = React.DOM
    searchString = @state.searchString.trim().toLowerCase()
    userContent = JSON.stringify @state.userInfo
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
      div id: 'user-info', searchString
      div id: 'user-content', userContent

React.render(
  React.createElement(SearchBar, null), document.getElementById('main')
)

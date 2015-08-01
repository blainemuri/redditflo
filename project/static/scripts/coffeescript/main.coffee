LIMIT = 100

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
        placeholder = 'Search users'
      button
        className: 'search-submit'
        type: 'submit'
        onClick: @handleSubmit
        'Submit'
      div id: 'user-info', searchString
      div id: 'user-content', userContent

LoginModal = React.createClass
  getInitialState: ->
    loggedIn: no

  handleSubmit: (event) ->
    @setState loggedIn: yes

  render: ->
    {button, div, img, input} = React.DOM
    div {},
    if @state.loggedIn
      ''
    else
      div className: 'outer-login',
        div className: 'inner-login',
          div {},
            img
              className: 'login-logo'
              src: './static/logo.png'
              alt: 'Redditflo'
          div {},
            input
              className: 'login-field'
              id: 'username'
              type: 'text'
              placeholder: 'Username'
          div {},
            input
              className: 'login-field'
              id: 'password'
              type: 'password'
              placeholder: 'Password'
          div {},
            button
              className: 'login-button'
              type: 'submit'
              onClick: @handleSubmit
              'Login'

Content = React.createClass
  render: ->
    {div} = React.DOM
    div {},
      React.createElement(LoginModal, null)
      div className: 'container',
        React.createElement(SearchBar, null)

React.render(
  React.createElement(Content, null), document.getElementById('main')
)

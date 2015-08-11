React = require('react')

Login = React.createClass
  getInitialState: ->
    loggedIn: no

  handleSubmit: (event) -> @props.login yes

  render: ->
    {button, div, img, input} = React.DOM
    div {},
      div className: 'outer-login',
        div className: 'inner-login',
          div {},
            img
              className: 'login-logo'
              src: 'images/logo.png'
              alt: 'Redditflo'
          div {},
            div className: 'loading', 'Loading'
            img 
              className: 'loading-gif'
              src: 'images/loading.gif'

module.exports =
  Login: Login

React = require('react')

Navbar = React.createClass
  render: ->
    {div, img, a, button} = React.DOM
    div className: 'header',
      div className: 'flip-container',
        div className: 'flipper',
          div className: 'front',
            div
              className: 'menu-triangle'
            img
              className: 'menu-icon'
              src: 'images/hamburger.png'
              alt: 'Redditflo'
          div className: 'back',
            div className: 'menu-buttons',
              button
                className: 'menu-button home'
                onClick: => @props.setCurrentPage 'home'
                'Home'
              button
                className: 'menu-button subscriptions'
                onClick: => @props.setCurrentPage 'subscriptions'
                'Subscriptions'
              button
                className: 'menu-button profile'
                onClick: => @props.setCurrentPage 'profile'
                'Profile'
              button
                className: 'menu-button logout'
                onClick: => @props.setCurrentPage 'logout'
                'Logout'
      img
        className: 'logo'
        src: 'images/logo.png'
      div
        className: 'login'
        "logged in as #{Python.getUser()}"

module.exports =
  Navbar: Navbar

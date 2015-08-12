React = require('react')

# Props
#   username
#   setCurrentPage
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
                onClick: => @props.setCurrentPage 'homepage'
                'Home'
              button
                className: 'menu-button subscriptions'
                onClick: => @props.setCurrentPage 'subscriptions'
                'Subscribe'
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
        "logged in as #{@props.username}"

module.exports =
  Navbar: Navbar

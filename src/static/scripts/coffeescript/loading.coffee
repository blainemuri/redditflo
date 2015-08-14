React = require('react')

Loading = React.createClass
  render: ->
    {div, img} = React.DOM
    div
      className: 'loading-feed'
      div className: 'loading-content',
        div className: 'loading-text', 'Loading'
        img
          className: 'loading-icon'
          src: 'images/loading.gif'

module.exports =
  Loading: Loading
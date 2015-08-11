React = require('react')

Content = React.createClass
  render: ->
    {div} = React.DOM
    div className: 'container', 'Logout page!'

module.exports =
  Logout: Content

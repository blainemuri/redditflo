React = require('react')

Content = React.createClass
  render: ->
    {div} = React.DOM
    div {}, 'Logout page!'

module.exports =
  Logout: Content
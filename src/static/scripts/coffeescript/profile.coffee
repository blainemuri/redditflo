React = require('react')

Content = React.createClass
  render: ->
    {div} = React.DOM
    div className: 'container', 'Profile page!'

module.exports =
  Profile: Content
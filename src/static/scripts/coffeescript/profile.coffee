React = require('react')

Content = React.createClass
  render: ->
    {div} = React.DOM
    div {}, 'Profile page!'

module.exports =
  Profile: Content
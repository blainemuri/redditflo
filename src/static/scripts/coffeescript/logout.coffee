React = require('react')

Content = React.createClass
  componentDidMount: ->
    @props.logout()

  render: ->
    {div} = React.DOM
    div className: 'container', 'Logout page!'

module.exports =
  Logout: Content

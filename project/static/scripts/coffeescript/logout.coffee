Content = React.createClass
  render: ->
    {div} = React.DOM
    div {},
      div className = 'container',
        "This is the logout page"

React.render(
  React.createElement(Content, null), document.getElementById('main')
)

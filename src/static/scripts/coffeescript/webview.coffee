React = require('react')

Webview = React.createClass
  render: ->
    {div} = React.DOM
    args = Object.keys(@props).map (k) => "#{k}=\"#{@props[k]}\""
    args = args.join(' ')
    content = "<webview #{args}></webview>"
    div className: "sub-content #{@props.color}",
      div
        className: "webview"
        dangerouslySetInnerHTML: __html: content

module.exports =
  Webview: Webview

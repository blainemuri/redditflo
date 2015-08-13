React = require('react')

Webview = React.createClass
  render: ->
    args = Object.keys(@props).map (k) => "#{k}=\"#{@props[k]}\""
    args = args.join(' ')
    content = "<webview #{args}></webview>"
    React.DOM.div
      dangerouslySetInnerHTML: __html: content

module.exports =
  Webview: Webview

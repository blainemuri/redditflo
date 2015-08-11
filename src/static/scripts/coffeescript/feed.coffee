marked = require('marked')
React = require('react')

Feed = React.createClass
  getInitialState: ->
    color: if @props.type is 'user' then 'card-blue' else 'card-orange'

  render: ->
    {button, div, span, img} = React.DOM
    author = @props.data.data.author
    content = marked @props.data.data.selftext
    key = @props.data.data.name
    thumbnail = @props.data.data.thumbnail
    title = marked @props.data.data.title
    div className: "feed-item #{@state.color}", key: key,
      div className: 'arrows',
        div {},
          button className: 'arrow-button',
            img className: 'up-arrow', src: 'images/arrow.png'
        div {},
          button className: 'arrow-button',
            img className: 'down-arrow', src: 'images/arrowdown.png'
      div className: 'content',
        div {},
          span dangerouslySetInnerHTML: __html: title
          span className: 'author', "  Author: #{author}"
        div dangerouslySetInnerHTML: __html: content
        if thumbnail isnt '' and thumbnail isnt 'self'
          div {}, img src: thumbnail

module.exports =
  Feed: Feed

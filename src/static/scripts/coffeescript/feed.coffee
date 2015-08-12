marked = require('marked')
Entities = require('html-entities').AllHtmlEntities
React = require('react')

Feed = React.createClass
  getInitialState: ->
    entities: new Entities()

  render: ->
    {button, div, span, img} = React.DOM
    author = @props.data.data.author
    color = if @props.data.type is 'user' then 'card-blue' else 'card-orange'
    content = marked @props.data.data.selftext
    content = @props.data.data.selftext_html
    content = @state.entities.decode if content? then content else ''
    thumbnail = @props.data.data.thumbnail
    title = marked @props.data.data.title
    div className: "feed-item #{color}",
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
        div className: 'no-click', dangerouslySetInnerHTML: __html: content
        if thumbnail isnt '' and thumbnail isnt 'self'
          div {}, img src: thumbnail

module.exports =
  Feed: Feed

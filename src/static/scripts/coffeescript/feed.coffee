marked = require('marked')
Entities = require('html-entities').AllHtmlEntities
React = require('react')

entities = new Entities()

decodeToHtml = (text) ->
  entities.decode text or ''

getInfo = (data) ->
  author: data.data.author
  color: if data.type is 'user' then 'card-blue' else 'card-orange'
  content: decodeToHtml(data.data.selftext_html or data.data.body_html)
  thumbnail: data.data.thumbnail or ''
  title: marked(data.data.title or data.data.link_title)
  url: data.data.url

Feed = React.createClass
  onClick: ->
    @props.onUrl @props.data.data.url

  render: ->
    {button, div, span, img} = React.DOM
    info = getInfo @props.data
    div className: "feed-item #{info.color}", onClick: @onClick,
      div className: 'arrows',
        div {},
          button className: 'arrow-button',
            img className: 'up-arrow', src: 'images/arrow.png'
        div {},
          button className: 'arrow-button',
            img className: 'down-arrow', src: 'images/arrowdown.png'
      div className: 'content',
        div {},
          span dangerouslySetInnerHTML: __html: info.title
          span className: 'author', "  Author: #{info.author}"
        div className: 'no-click', dangerouslySetInnerHTML: __html: info.content
        if info.thumbnail isnt '' and info.thumbnail isnt 'self'
          div {}, img src: info.thumbnail

module.exports =
  Feed: Feed

marked = require('marked')
Entities = require('html-entities').AllHtmlEntities
React = require('react')

{Webview} = require('redditflo/webview')

entities = new Entities()

decodeToHtml = (text) ->
  entities.decode text or ''

getInfo = (data) ->
  author: data.data.author
  color: if data.type is 'user' then 'card-blue' else 'card-orange'
  content: decodeToHtml(data.data.selftext_html or data.data.body_html)
  date: (new Date data.data.created_utc * 1000).toString()
  downvotes: data.data.downs
  id: data.data.name
  redditLink: "https://www.reddit.com#{data.data.permalink}"
  subreddit: data.data.subreddit
  thumbnail: data.data.thumbnail or ''
  title: marked(data.data.title or data.data.link_title)
  url: data.data.url
  upvotes: data.data.ups

Feed = React.createClass
  getInitialState: ->
    expanded: ''

  render: ->
    {button, div, span, img} = React.DOM
    info = getInfo @props.data

    span {},
      div
        className: "feed-item #{info.color}"
        div className: 'arrows',
          div {},
            button className: 'arrow-button',
              img className: 'up-arrow', src: 'images/arrow.png'
          div {},
            button className: 'arrow-button',
              img className: 'down-arrow', src: 'images/arrowdown.png'
          div {},
            button
              className: 'arrow-button'
              onClick: (=> @setState expanded: if @state.expanded is 'red' then '' else 'red'),
              img className: 'down-arrow', src: 'images/reddit-alien.png'
        div className: 'content', onClick: (=> @setState expanded: if @state.expanded is 'ext' then '' else 'ext'),
          div {},
            span dangerouslySetInnerHTML: __html: info.title
            span className: 'author', "  Author: #{info.author}"
          div className: 'no-click', dangerouslySetInnerHTML: __html: info.content
          if info.thumbnail isnt '' and info.thumbnail isnt 'self'
            div {}, img src: info.thumbnail
      if @state.expanded is 'ext'
        React.createElement Webview,
          src: info.url
          style: "display:inline-block; width:100%; height:480px"
      else if @state.expanded is 'red'
        React.createElement Webview,
          src: info.redditLink
          style: "display:inline-block; width:100%; height:480px"


module.exports =
  Feed: Feed

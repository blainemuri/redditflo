marked = require('marked')
Entities = require('html-entities').AllHtmlEntities
React = require('react')
Python = require('redditflo/python')

{Webview} = require('redditflo/webview')

entities = new Entities()

decodeToHtml = (text) ->
  entities.decode text or ''

getInfo = (data) ->
  author: data.data.author
  color: if data.type is 'user' then 'card-blue' else 'card-orange'
  commentCount: data.data.num_comments
  content: decodeToHtml(data.data.selftext_html or data.data.body_html)
  date: (new Date data.data.created_utc * 1000).toString()
  downvotes: data.data.downs
  score: data.data.score
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
    currentVote: 0

  componentDidMount: -> @props.notLoading()

  sendDownvote: (e, id) ->
    e.stopPropagation()
    if @state.currentVote is 0 or @state.currentVote is 1
      Python.updateVote(id, '-1')
      @setState currentVote: -1
    else
      Python.updateVote(id, '0')
      @setState currentVote: 0

  sendUpvote: (e, id) ->
    e.stopPropagation()
    if @state.currentVote is 0 or @state.currentVote is -1
      Python.updateVote(id, '1')
      @setState currentVote: 1
    else
      Python.updateVote(id, '0')
      @setState currentVote: 0

  reddit: (e) ->
    e.stopPropagation()
    @setState expanded: if @state.expanded is 'red' then '' else 'red'

  render: ->
    {button, div, span, img} = React.DOM
    info = getInfo @props.data

    span {},
      div className: "feed-item #{info.color}", onClick: (=> @setState expanded: if @state.expanded is 'ext' then '' else 'ext'),
        div className: 'arrows',
          div {},
            button
              className: "arrow-button #{'pressed' if @state.currentVote is 1}"
              onClick: (e) => @sendUpvote e, info.id
              img className: 'up-arrow', src: 'images/arrow.png'
          div {},
            button
              className: "arrow-button #{'pressed' if @state.currentVote is -1}"
              onClick: (e) => @sendDownvote e, info.id
              img className: 'down-arrow', src: 'images/arrowdown.png'
          div {},
            button
              className: 'arrow-button'
              onClick: (e) => @reddit e
              img className: 'down-arrow', src: 'images/reddit-alien.png'
        div className: 'content',
          div className: 'upper-content',
            span className: 'feed-title', dangerouslySetInnerHTML: __html: info.title
            div className: 'author', "  Author: #{info.author}"
            div className: 'subreddit', "  Subreddit: #{info.subreddit}"
          div className: 'no-click main-content', dangerouslySetInnerHTML: __html: info.content
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

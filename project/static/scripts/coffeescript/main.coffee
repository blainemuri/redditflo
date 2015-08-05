LIMIT = 10

SearchBar = React.createClass
  getInitialState: ->
    searchString: ''
    userInfo: {}

  handleChange: (event) ->
    @setState searchString: event.target.value

  handleSubmit: (event) ->
    cback = (data, status) =>
      if status is 'success'
        @setState userInfo: data
      else
        console.log status
    username = @state.searchString
    redditRequest "/user/#{username}", {limit:LIMIT}, cback

  render: ->
    {button, div, input} = React.DOM
    searchString = @state.searchString.trim().toLowerCase()
    userContent = JSON.stringify @state.userInfo
    div className: 'search-box',
      div className: 'title', 'Follow reddit users'
      input
        className: 'search-text'
        type: 'text'
        value: @state.searchString
        onChange: @handleChange
        placeholder: 'Search users'
      button
        className: 'search-submit'
        type: 'submit'
        onClick: @handleSubmit
        'Submit'
      div id: 'user-info', searchString
      div id: 'user-content', userContent

Feed = React.createClass
  render: ->
    {div, span} = React.DOM
    div className: 'feed-element',
      div {},
        span dangerouslySetInnerHTML: __html: marked @props.data.title
        span {}, "Author: #{@props.data.author}"
      div dangerouslySetInnerHTML: __html: marked @props.data.selftext

Content = React.createClass
  getInitialState: ->
    subscriptions: [
      type: "user",
      name: "btoxic",
      filters: [
        excludeTags: ['NSFW']
      ]
    ,
      type: "subreddit",
      name: "happiness",
      filters: [
        contains: "happy"
      ,
        includeTags: ['NSFW']
      ]
    ]
    rawFeed: {}

  componentDidMount: ->
    @fetchFeed()

  fetchFeed: ->
    f = (key) =>
      (data, status) =>
        rawFeed = @state.rawFeed
        rawFeed["#{key}"] = data
        @setState rawFeed: rawFeed
    @state.subscriptions.forEach (sub) ->
      url = if sub.type is "user" then "/user/" else "/r/"
      url += sub.name
      if sub.type is "user"
        url += "/submitted"
      redditRequest url,
        limit: LIMIT
        f "#{sub.type}_#{sub.name}"

  getFeedList: ->
    rawFeed = @state.rawFeed
    subs = Object.keys(rawFeed)
    _.flatten(
      subs.map (sub) =>
        @state.rawFeed[sub].data.children.map (data) -> data
    )

  render: ->
    {div, img} = React.DOM
    div {},
      div className: 'container',
        React.createElement(SearchBar, null)
        @getFeedList().map (content) ->
          div {},
            '----------------------------------------------------------------'
            React.createElement(Feed, content)

React.render(
  React.createElement(Content, null), document.getElementById('main')
)

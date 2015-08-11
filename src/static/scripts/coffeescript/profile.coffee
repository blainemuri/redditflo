React = require('react')
$ = require('jquery')
Dropzone = require('dropzone')

Uploader = React.createClass
  getInitialState: ->
    src: "images/#{@props.username}.jpg"

  componentDidMount: ->
    Dropzone.autoDiscover = no
    myDropzone = new Dropzone(@getDOMNode(), {url: '/file/upload'})
    img = new Image()
    img.onerror = (=>
      @setState src: 'images/blank-user.png')
    img.src = @state.src

  render: ->
    {div, form, img} = React.DOM
    div {},
      form
        action: '/file/upload'
        className: 'dropzone'
        id: 'dropzone'
        div className: 'dz-default dz-message text-center',
          img
            className: 'dropzone-inner'
            src: "#{@state.src}"

Content = React.createClass
  render: ->
    {div, form, img} = React.DOM
    div className: 'container',
      React.createElement(Uploader, {})
      div className: 'profile-info',
        div className: 'username', "@#{@props.username}"
        div className: 'following', "Following: #{@props.following} redditors"

module.exports =
  Profile: Content
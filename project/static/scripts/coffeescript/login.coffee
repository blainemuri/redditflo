LoginModal = React.createClass
  getInitialState: ->
    blah: ''

  handleSubmit: (event) ->
    @setState loggedIn: yes
    $.ajax
      type: 'POST',
      url: '/login',
      data: JSON.stringify(data, null, '\t'),
      success: (data) -> alert JSON.stringify(data),
      contentType: 'application/json;charset=UTF-8'

  render: ->
    {button, div, img, input} = React.DOM
    div {},
      if @state.loggedIn
        ''
      else
        div className: 'outer-login',
          div className: 'inner-login',
            div {},
              img
                className: 'login-logo'
                src: './static/logo.png'
                alt: 'Redditflo'
            div {},
              button
                className: 'login-button'
                type: 'submit'
                onClick: @handleSubmit
                'Login'
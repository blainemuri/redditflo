(function() {
  var Content, LoginModal, SearchBar;

  SearchBar = React.createClass({
    getInitialState: function() {
      return {
        searchString: ''
      };
    },
    handleChange: function(event) {
      return this.setState({
        searchString: event.target.value
      });
    },
    handleSubmit: function(event) {
      return null;
    },
    render: function() {
      var button, div, input, placeholder, ref, searchString;
      ref = React.DOM, button = ref.button, div = ref.div, input = ref.input;
      searchString = this.state.searchString.trim().toLowerCase();
      return div({
        className: 'search-box'
      }, div({
        className: 'title'
      }, 'Follow reddit users'), input({
        className: 'search-text',
        type: 'text',
        value: this.state.searchString,
        onChange: this.handleChange
      }, placeholder = 'Search users'), button({
        className: 'search-submit',
        type: 'submit',
        onClick: this.handleSubmit
      }, 'Submit'), div({
        id: 'user-info'
      }, searchString));
    }
  });

  LoginModal = React.createClass({
    getInitialState: function() {
      return {
        loggedIn: false
      };
    },
    handleSubmit: function(event) {
      return this.setState({
        loggedIn: true
      });
    },
    render: function() {
      var button, div, img, input, ref;
      ref = React.DOM, button = ref.button, div = ref.div, img = ref.img, input = ref.input;
      return div({}, this.state.loggedIn ? '' : div({
        className: 'outer-login'
      }, div({
        className: 'inner-login'
      }, div({}, img({
        className: 'login-logo',
        src: './static/logo.png',
        alt: 'Redditflo'
      })), div({}, input({
        className: 'login-field',
        id: 'username',
        type: 'text',
        placeholder: 'Username'
      })), div({}, input({
        className: 'login-field',
        id: 'password',
        type: 'password',
        placeholder: 'Password'
      })), div({}, button({
        className: 'login-button',
        type: 'submit',
        onClick: this.handleSubmit
      }, 'Login')))));
    }
  });

  Content = React.createClass({
    render: function() {
      var div;
      div = React.DOM.div;
      return div({}, React.createElement(LoginModal, null), div({
        className: 'container'
      }, React.createElement(SearchBar, null)));
    }
  });

  React.render(React.createElement(Content, null), document.getElementById('main'));

}).call(this);

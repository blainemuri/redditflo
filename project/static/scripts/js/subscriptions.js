(function() {
  var LIMIT, SearchBar;

  LIMIT = 10;

  SearchBar = React.createClass({
    getInitialState: function() {
      return {
        searchString: '',
        userInfo: {}
      };
    },
    handleChange: function(event) {
      return this.setState({
        searchString: event.target.value
      });
    },
    handleSubmit: function(event) {
      var cback, username;
      cback = (function(_this) {
        return function(data, status) {
          if (status === 'success') {
            return _this.setState({
              userInfo: data
            });
          } else {
            return console.log(status);
          }
        };
      })(this);
      username = this.state.searchString;
      return redditRequest("/user/" + username, {
        limit: LIMIT
      }, cback);
    },
    render: function() {
      var button, div, input, ref, searchString, userContent;
      ref = React.DOM, button = ref.button, div = ref.div, input = ref.input;
      searchString = this.state.searchString.trim().toLowerCase();
      userContent = JSON.stringify(this.state.userInfo);
      return div({
        className: 'search-box'
      }, div({
        className: 'title'
      }, 'Follow reddit users'), input({
        className: 'search-text',
        type: 'text',
        value: this.state.searchString,
        onChange: this.handleChange,
        placeholder: 'Search users'
      }), button({
        className: 'search-submit',
        type: 'submit',
        onClick: this.handleSubmit
      }, 'Submit'), div({
        id: 'user-info'
      }, searchString), div({
        id: 'user-content'
      }, userContent));
    }
  });

  React.render(React.createElement(SearchBar, null), document.getElementById('main'));

}).call(this);

(function() {
  var LoginModal;

  LoginModal = React.createClass({
    getInitialState: function() {
      return {
        blah: ''
      };
    },
    handleSubmit: function(event) {
      this.setState({
        loggedIn: true
      });
      return $.ajax({
        type: 'POST',
        url: '/login',
        data: JSON.stringify(data, null, '\t'),
        success: function(data) {
          return alert(JSON.stringify(data));
        },
        contentType: 'application/json;charset=UTF-8'
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
      })), div({}, button({
        className: 'login-button',
        type: 'submit',
        onClick: this.handleSubmit
      }, 'Login')))));
    }
  });

}).call(this);

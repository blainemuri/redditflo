/** @jsx React.DOM */

var LoginModal = React.createClass({

  render: function() {
  	<div className="login-modal">
  		This is the login modal
  	</div>
  }
});
React.render(
	<LoginModal />,
	document.getElementById('login-modal')
);
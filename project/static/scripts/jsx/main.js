/** @jsx React.DOM */

var SearchBar = React.createClass({

  // sets initial state
  getInitialState: function() {
    return {searchString: ''};
  },

  // sets state, triggers render method
  handleChange: function(event) {
    // grab value form input box
    this.setState({searchString: event.target.value});
  },

  handleSubmit: function(event) {
    //Will, work your magic here
  },

  render: function() {
    var searchString = this.state.searchString.trim().toLowerCase();

    return (
      <div className="search-box">
        <div className="title">Follow reddit users</div>
        <input className="search-text" type="text" value={this.state.searchString} onChange={this.handleChange} placeholder="Search users..."></input>
        <button className="search-submit" type="submit" onClick={this.handleSubmit}>Submit</button>
        <div id="user-info">{searchString}</div>
      </div>
    );
  }
});

var LoginModal = React.createClass({
  //need to refactor the loggedIn to check instead whether the user is valid
  getInitialState: function() {
    return {
      loggedIn: false
    }
  },

  handleSubmit: function(event) {
    this.setState({loggedIn: true})
  },

  render: function() {
    var login;
    if (!this.state.loggedIn) {
      login =
        <div className="outer-login">
          <div className="inner-login">
            <div><img className="login-logo" src={'/static/logo.png'} alt="Redditflo"></img></div>
            <div><input className="login-field" id="username" type="text" placeholder="Username"></input></div>
            <div><input className="login-field" id="password" type="password" placeholder="Password"></input></div>
            <div><button className="login-button" type="submit" onClick={this.handleSubmit}>Login</button></div>
          </div>
        </div>
    } else {
      login = <div></div>
    }

    return (
      <div>
        {login}
      </div>
    );
  }
});

var Content = React.createClass({

  render: function() {
    return (
      <div>
        <LoginModal />
        <div className="container">
          <SearchBar />
        </div>
      </div>
    );
  }
});

React.render(
  <Content />,
  document.getElementById('main')
);
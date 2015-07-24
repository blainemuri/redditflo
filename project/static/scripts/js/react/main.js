(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/** @jsx React.DOM */

var SearchBar = React.createClass({displayName: "SearchBar",

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
      React.createElement("div", {className: "search-box"}, 
        React.createElement("div", {className: "title"}, "Follow reddit users"), 
        React.createElement("input", {className: "search-text", type: "text", value: this.state.searchString, onChange: this.handleChange, placeholder: "Search users..."}), 
        React.createElement("button", {className: "search-submit", type: "submit", onClick: this.handleSubmit}, "Submit"), 
        React.createElement("div", {id: "user-info"}, searchString)
      )
    );
  }
});

var LoginModal = React.createClass({displayName: "LoginModal",
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
        React.createElement("div", {className: "outer-login"}, 
          React.createElement("div", {className: "inner-login"}, 
            React.createElement("div", null, React.createElement("img", {className: "login-logo", src: '/static/logo.png', alt: "Redditflo"})), 
            React.createElement("div", null, React.createElement("input", {className: "login-field", id: "username", type: "text", placeholder: "Username"})), 
            React.createElement("div", null, React.createElement("input", {className: "login-field", id: "password", type: "password", placeholder: "Password"})), 
            React.createElement("div", null, React.createElement("button", {className: "login-button", type: "submit", onClick: this.handleSubmit}, "Login"))
          )
        )
    } else {
      login = React.createElement("div", null)
    }

    return (
      React.createElement("div", null, 
        login
      )
    );
  }
});

var Content = React.createClass({displayName: "Content",

  render: function() {
    return (
      React.createElement("div", null, 
        React.createElement(LoginModal, null), 
        React.createElement("div", {className: "container"}, 
          React.createElement(SearchBar, null)
        )
      )
    );
  }
});

React.render(
  React.createElement(Content, null),
  document.getElementById('main')
);

},{}]},{},[1])
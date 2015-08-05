(function() {
  var Content;

  Content = React.createClass({
    render: function() {
      var className, div;
      div = React.DOM.div;
      return div({}, div(className = 'container', "This is the profile page"));
    }
  });

  React.render(React.createElement(Content, null), document.getElementById('main'));

}).call(this);

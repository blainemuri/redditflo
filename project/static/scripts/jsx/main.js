/** @jsx React.DOM */

var SearchBar = React.createClass({
  render: function() {
    return (
      <input className="commentBox">Hello, world! I am a CommentBox.</input>
    );
  }
});
React.render(
  <SearchBar />,
  document.getElementById('main')
);
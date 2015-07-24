/** @jsx React.DOM */

var SearchBar = React.createClass({

  // sets initial state
  getInitialState: function(){
    return { searchString: '' };
  },

  // sets state, triggers render method
  handleChange: function(event){
    // grab value form input box
    this.setState({searchString:event.target.value});
  },

  handleSubmit: function(event){
    //Will, work your magic here
  },

  render: function() {
    var searchString = this.state.searchString.trim().toLowerCase();

    return (
      <div className="search-box">
        <input className="search-text" type="text" value={this.state.searchString} onChange={this.handleChange} placeholder="Search users..."></input>
        <button className="search-submit" type="submit" onClick={this.handleSubmit}>Submit</button>
        <div id="user-info">{searchString}</div>
      </div>
    );
  }
});
React.render(
  <SearchBar />,
  document.getElementById('main')
);
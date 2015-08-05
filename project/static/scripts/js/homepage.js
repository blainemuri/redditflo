(function() {
  var Content, Feed, LIMIT;

  LIMIT = 10;

  Feed = React.createClass({
    render: function() {
      var div, ref, span;
      ref = React.DOM, div = ref.div, span = ref.span;
      return div({
        className: 'feed-element'
      }, div({}, span({
        dangerouslySetInnerHTML: {
          __html: marked(this.props.data.title)
        }
      }), span({}, "Author: " + this.props.data.author)), div({
        dangerouslySetInnerHTML: {
          __html: marked(this.props.data.selftext)
        }
      }));
    }
  });

  Content = React.createClass({
    getInitialState: function() {
      return {
        subscriptions: [
          {
            type: "user",
            name: "btoxic",
            filters: [
              {
                excludeTags: ['NSFW']
              }
            ]
          }, {
            type: "subreddit",
            name: "happiness",
            filters: [
              {
                contains: "happy"
              }, {
                includeTags: ['NSFW']
              }
            ]
          }
        ],
        rawFeed: {}
      };
    },
    componentDidMount: function() {
      return this.fetchFeed();
    },
    fetchFeed: function() {
      var f;
      f = (function(_this) {
        return function(key) {
          return function(data, status) {
            var rawFeed;
            rawFeed = _this.state.rawFeed;
            rawFeed["" + key] = data;
            return _this.setState({
              rawFeed: rawFeed
            });
          };
        };
      })(this);
      return this.state.subscriptions.forEach(function(sub) {
        var url;
        url = sub.type === "user" ? "/user/" : "/r/";
        url += sub.name;
        if (sub.type === "user") {
          url += "/submitted";
        }
        return redditRequest(url, {
          limit: LIMIT
        }, f(sub.type + "_" + sub.name));
      });
    },
    getFeedList: function() {
      var rawFeed, subs;
      rawFeed = this.state.rawFeed;
      subs = Object.keys(rawFeed);
      return _.flatten(subs.map((function(_this) {
        return function(sub) {
          return _this.state.rawFeed[sub].data.children.map(function(data) {
            return data;
          });
        };
      })(this)));
    },
    render: function() {
      var div, img, ref;
      ref = React.DOM, div = ref.div, img = ref.img;
      return div({}, div({
        className: 'container'
      }, this.getFeedList().map(function(content) {
        return div({}, '----------------------------------------------------------------', React.createElement(Feed, content));
      })));
    }
  });

  React.render(React.createElement(Content, null), document.getElementById('main'));

}).call(this);

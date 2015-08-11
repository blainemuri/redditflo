var app = require('app');
var BrowserWindow = require('browser-window');

var mainWindow = null
app.on('ready', function() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 720
  });
  return mainWindow.loadUrl('file://' + __dirname + '/static/index.html');
});

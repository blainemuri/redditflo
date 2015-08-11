var app = require('app');
var BrowserWindow = require('browser-window');

var mainWindow = null
app.on('ready', function() {
  mainWindow = new BrowserWindow({
    width: 720,
    height: 480
  });
  return mainWindow.loadUrl('file://' + __dirname + '/static/index.html');
});

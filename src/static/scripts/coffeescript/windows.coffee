remote = require('remote')
BrowserWindow = remote.require('browser-window')

windows =
  reddit: null

module.exports =
  setReddit: (url) ->
    if not windows.reddit?
      windows.reddit = new BrowserWindow {}
      windows.reddit.on 'close', -> windows.reddit = null
    if not url?
      windows.reddit.close()
    else
      windows.reddit.loadUrl url
    true

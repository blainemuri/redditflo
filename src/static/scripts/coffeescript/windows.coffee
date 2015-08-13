remote = require('remote')
BrowserWindow = remote.require('browser-window')

windows =
  reddit: null

settings =
  windowParameters:
    frame: false

module.exports =
  settings: settings

  setReddit: (url) ->
    if not windows.reddit?
      windows.reddit = new BrowserWindow settings.windowParameters
      windows.reddit.on 'close', -> windows.reddit = null
    if not url?
      windows.reddit.close()
    else
      windows.reddit.loadUrl url
      windows.reddit.focus()
    true

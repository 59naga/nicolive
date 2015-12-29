path= require 'path'

class Nicolive extends require './session'
  login:
    require './nicolive/login'
  logout:
    require './nicolive/logout'

  ping:
    require './nicolive/ping'
  getPlayerStatus:
    require './nicolive/get-player-status'
  getPostKey:
    require './nicolive/get-post-key'

  view:
    require './nicolive/view'
  comment:
    require './nicolive/comment'

  createStream:
    require './nicolive/create-stream'

  # Login unnecessary
  fetchNickname:
    require './nicolive/fetch-nickname'

  # bin
  cli:
    require './nicolive/cli'

module.exports= new Nicolive path.resolve __dirname,'..','nicolive.json'
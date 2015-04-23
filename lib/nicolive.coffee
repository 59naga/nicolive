path= require 'path'

class Nicolive extends require './session'
  login:
    require './nicolive/login'
  logout:
    require './nicolive/logout'

  ping:
    require './nicolive/ping'
  view:
    require './nicolive/view'
  comment:
    require './nicolive/comment'

  # Login unnecessary
  fetchNickname:
    require './nicolive/fetch-nickname'

  # Utility method
  parse:
    require './nicolive/parse'

  # bin
  cli:
    require './nicolive/cli'

module.exports= new Nicolive path.resolve __dirname,'..','nicolive.json'
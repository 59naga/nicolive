fs= require 'fs'

class Session
  constructor: (@path)->
    @path= @path+'.json' unless @path.match /.json$/

    @cache= {}
    @cache= require @path if fs.existsSync @path

  set: (cookie)-> @cache.cookie= cookie
  get: -> @cache.cookie

  save: ->
    fs.writeFileSync @path,JSON.stringify @cache
    delete require.cache[require.resolve @path]

  destroy: ->
    return unless fs.existsSync @path

    @cache= {}

    fs.unlinkSync @path
    delete require.cache[require.resolve @path]

module.exports= Session
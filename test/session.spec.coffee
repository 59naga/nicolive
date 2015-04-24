Session= require '../lib/session'

fs= require 'fs'
path= require 'path'

session= null
sessionCache= path.resolve __dirname,'..','nicolive'

describe 'Session',->
  it '.constructor',->
    session= new Session sessionCache

    expect(session.path).toEqual sessionCache+'.json'

  it '.set',->
    session.set "hoge=fuga;"

    expect(session.cache.cookie).toEqual "hoge=fuga;" 

  it '.save',->
    session.save()
    cache= require sessionCache+'.json'

    expect(cache.cookie).toEqual "hoge=fuga;"

  it '.get',->
    cookie= session.get()

    expect(cookie).toEqual "hoge=fuga;" 

  it '.destroy',->
    session.destroy()

    expect((-> require sessionCache+'.json')).toThrow()

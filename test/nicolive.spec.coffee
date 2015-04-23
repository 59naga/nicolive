nicolive= require '../lib/nicolive'
cheerio= require 'cheerio'
EventEmitter= (require 'events').EventEmitter

api= require '../lib/api'

id= new Buffer(process.env.LOGIN_ID,'base64').toString()
pw= new Buffer(process.env.LOGIN_PW,'base64').toString()

describe 'nicolive',->
  describe 'login',->
    it 'Not login',(done)->
      nicolive.destroy()
      nicolive.ping (error,pong)->
        expect(error).toEqual 'notlogin'
        expect(pong).toBe false

        done()

    it 'Login',(done)->
      nicolive.login id,pw,(error,cookie)->
        expect(error).toBe null
        expect(cookie).toMatch 'user_session=user_session'

        done()

    it 'Logged in',(done)->
      nicolive.ping (error,pong)->
        expect(error).toBe null
        expect(pong).toBe yes

        done()

  describe 'fetchNickname',->
    it 'Found',(done)->
      nicolive.fetchNickname 143728,(error,nickname)->
        expect(error).toBe null
        expect((require '../package').author).toContain nickname

        done()
    it 'Not found',(done)->
      nicolive.fetchNickname 0,(error,nickname)->
        expect(error).toBe null
        expect(nickname).toEqual '-'

        done()
  
  describe 'view',->
    it 'nsen',(done)->
      nicolive.view 'lv218499873',(error,viewer)->
        expect(error).toBe null
        expect(viewer instanceof EventEmitter).toBeTruthy()

        done()

  describe 'login',->
    it 'Logged in',(done)->
      nicolive.ping (error,pong)->
        expect(error).toBe null
        expect(pong).toBe yes

        done()

    it 'Logout',(done)->
      nicolive.logout (error,statusCode)->
        expect(error).toBe null
        expect(statusCode).toEqual 302

        done()

    it 'Not login',(done)->
      nicolive.ping (error,pong)->
        expect(error).toEqual 'notlogin'
        expect(pong).toBe false

        done()

nicolive= require '../lib/nicolive'
cheerio= require 'cheerio'
EventEmitter= (require 'events').EventEmitter

api= require '../lib/api'

id= new Buffer(process.env.LOGIN_ID,'base64').toString()
pw= new Buffer(process.env.LOGIN_PW,'base64').toString()

describe 'nicolive',->
  describe '.login',->
    it 'Not login',(done)->
      nicolive.destroy()
      nicolive.ping (error)->
        expect(error).toEqual 'notlogin'

        done()

    it 'Login',(done)->
      nicolive.login id,pw,(error,cookie)->
        expect(error).toBe null
        expect(cookie).toMatch 'user_session=user_session'

        done()

    it 'Logged in',(done)->
      nicolive.ping (error,playerStatus)->
        expect(error).toBe null
        expect(playerStatus.version).toEqual '20061206'

        done()

  describe '.fetchNickname',->
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
  
  describe '.view',->
    it 'nsen/vocaloid',(done)->
      nicolive.view 'nsen/vocaloid',(error,viewer)->
        expect(error).toBe null
        expect(viewer instanceof EventEmitter).toBe true

        done()

  describe '.comment',->
    it 'nsen/hotaru',(done)->
      nicolive.view 'nsen/hotaru',(error,viewer)->
        expect(error).toBe null
        expect(viewer instanceof EventEmitter).toBe true

        viewer.on 'error',(error)-> throw error
        viewer.on 'handshaked',->
          text= 'node-nicolive comment test at '+(new Date)
          text+= ' via Travis-CI' if process.env.COVERALLS_REPO_TOKEN
          nicolive.comment text,(error,status)->
            expect(error).toBe null
            expect(status).toBe '0'

            done()

  describe '.logout',->
    it 'Logged in',(done)->
      nicolive.ping (error,playerStatus)->
        expect(error).toBe null
        expect(playerStatus.version).toEqual '20061206'

        done()

    it 'Logout',(done)->
      nicolive.logout (error,statusCode)->
        expect(error).toBe null
        expect(statusCode).toEqual 302

        done()

    it 'Not login',(done)->
      nicolive.ping (error)->
        expect(error).toEqual 'notlogin'

        done()

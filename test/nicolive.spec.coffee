nicolive= require '../lib/nicolive'
EventEmitter= (require 'events').EventEmitter

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

  describe '.view',->
    it 'nsen/vocaloid',(done)->
      nicolive.view 'nsen/vocaloid',(error,viewer)->
        expect(error).toBe null
        expect(viewer instanceof EventEmitter).toBe true

        done()

  describe '.comment',->
    text= 'node-nicolive comment test at '+(new Date)
    text+= ' via Travis-CI' if process.env.COVERALLS_REPO_TOKEN

    it 'nsen/hotaru',(done)->
      nicolive.view 'nsen/hotaru',(error,viewer)->
        expect(error).toBe null
        expect(viewer instanceof EventEmitter).toBe true

        viewer.on 'handshaked',->
          lastRes= parseInt nicolive.playerStatus.last_res
          nicolive.comment text,(error,chat)->
            expect(chat.attr 'thread').toBe nicolive.playerStatus.thread
            expect(chat.attr 'status').toBe '0'
            expect(chat.attr 'no').toBe (lastRes+1).toString()

            done()

    it 'nsen/hotaru (Status is 1)',(done)->
      nicolive.view 'nsen/hotaru',(error,viewer)->
        expect(error).toBe null
        expect(viewer instanceof EventEmitter).toBe true

        viewer.on 'handshaked',->
          lastRes= parseInt nicolive.playerStatus.last_res
          nicolive.comment text,(error,chat)->
            expect(error instanceof Error).toBe true
            expect(chat.attr 'thread').toBe nicolive.playerStatus.thread
            expect(chat.attr 'status').toBe '1'
            expect(chat.attr 'no').toBe undefined

            console.log chat.attr()

            done()

  describe '.ping',->
    it 'Fetch playerStatus by nsen/vocaloid',(done)->
      nicolive.ping (error,playerStatus)->
        expect(error).toBe null
        expect(playerStatus.version).toBe '20061206'
        expect(playerStatus.addr).toContain 'live.nicovideo.jp'
        expect(playerStatus.res_from).toBe 0

        done()

  describe '.getPlayerStatus',->
    it 'Fetch playerStatus by live_id',(done)->
      nicolive.getPlayerStatus 'nsen/hotaru',(error,playerStatus)->
        expect(error).toBe null
        expect(playerStatus.version).toBe '20061206'
        expect(playerStatus.addr).toContain 'live.nicovideo.jp'
        expect(playerStatus.res_from).toBe 0

        done()

  describe '.getPostKey',->
    it 'Fetch postkey by (last_les+1)/100',(done)->
      nicolive.getPostKey (error,postKey)->
        expect(error).toBe null
        expect(postKey[0]).toBe '.'

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

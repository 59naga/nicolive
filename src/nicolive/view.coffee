request= require 'request'
cheerio= require 'cheerio'

net= require 'net'

chalk= require 'chalk'
h1= chalk.underline.magenta

{url,resultcode}= require '../api'

module.exports= (live_id,args...,callback)->
  options= args[0] ? {}

  @getPlayerStatus live_id,options,(error,body,playerStatus)=>
    return callback error if error?
    @playerStatus= playerStatus
    {
      port,addr
      thread,version,res_from
      user_id,premium,mail
    }= playerStatus

    if options.verbose
      console.log h1('Connect to'),"""
      http://#{addr}:#{port}/api/thread?thread=#{thread}&version=#{version}&res_from=#{res_from}
      """
      console.log h1('Or  static'),"""
      http://#{addr}:#{port-2725}/api/thread?thread=#{thread}&version=#{version}&res_from=#{res_from}
      """

    @viewer.destroy() if @viewer?
    @viewer= net.connect port,addr
    @viewer.on 'connect',=>
      comment= cheerio '<thread />'
      comment.attr {thread,version,res_from}
      comment.options.xmlMode= on

      @viewer.write comment.toString()+'\0'
      @viewer.setEncoding 'utf-8'

    chunks= ''
    @viewer.on 'data',(buffer)=>
      chunk= buffer.toString()
      chunks+= chunk
      return unless chunk.match /\0$/

      console.log h1('Received raw'),chunks if options.verbose
      data= cheerio '<data>'+chunks+'</data>'
      chunks= ''

      resultcodeValue= data.find('thread').attr 'resultcode'
      if resultcodeValue?.length
        {code,description}= resultcode[resultcodeValue]
        foundThread= data.find 'thread'
        ticket= foundThread.attr 'ticket'

        console.log h1('Resultcode '+resultcodeValue),code,description unless @test
        if options.verbose and resultcodeValue is '0'
          console.log h1('Thread'),foundThread.attr()
          if resultcodeValue is '0'
            console.log h1('Chat'),{thread,ticket,mail,user_id,premium}

        @playerStatus.last_res= foundThread.attr 'last_res'
        @attrs= {thread,ticket,mail,user_id,premium}

        if resultcodeValue is '0'
          @viewer.emit 'handshaked',@attrs,@playerStatus
        else
          @viewer.emit 'error',data.find('thread').toString()

      comments= data.find 'chat'
      for comment in comments
        element= cheerio comment

        comment=
          attr: element.attr()
          text: element.text()
          usericon: url.usericonEmptyURL

        {anonymity,user_id}= comment.attr
        unless anonymity?
          comment.usericon= url.usericonURL+user_id.slice(0,2)+'/'+user_id+'.jpg' if user_id

        @viewer.emit 'comment',comment
        @playerStatus.last_res= comment.attr.no if comment.attr.no>@playerStatus.comment_count

    callback null,@viewer
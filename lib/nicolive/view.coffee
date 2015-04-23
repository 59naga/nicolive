request= require 'request'
cheerio= require 'cheerio'

net= require 'net'

chalk= require 'chalk'
h1= chalk.underline.magenta

api= require '../api'
resultcodes= (require '../resultcodes').resultcodes

module.exports= (live,args...,callback)->
  id= live.match(/lv\d+/)?[0]
  options= args[0] ? {}
  return callback 'Invalid live: '+live unless id?

  console.log h1('Request to'),api.view+id if options.verbose

  request
    url: api.view+id
    headers:
      Cookie: @get()
  ,(error,res,body)=>
    errorMessage= cheerio(body).find('error description').text()
    return callback error if error?
    return callback errorMessage if errorMessage.length

    {
      port,addr
      thread,version,res_from
      user_id,premium,mail
      playerStatus
    }= @parse body,options

    console.log h1('Request to'),api.comment+thread if options.verbose

    request
      url: api.comment+thread
      headers:
        Cookie: @get()
    ,(error,res,postkeyBody)=>
      [...,postkey]= postkeyBody.split '='
      return callback error if error?

      viewer= net.connect port,addr
      viewer.on 'connect',->
        comment= cheerio '<thread />'
        comment.attr {thread,version,res_from}
        comment.options.xmlMode= on

        viewer.write comment.toString()+'\0'
        viewer.setEncoding 'utf-8'

      chunks= ''
      viewer.on 'data',(buffer)=>
        chunk= buffer.toString()
        chunks+= chunk
        return unless chunk.match /\u0000$/

        console.log chunks if options.verbose
        data= cheerio '<data>'+chunks+'</data>'
        chunks= ''

        resultcode= data.find('thread').attr 'resultcode'
        if resultcode?.length
          {code,description}= resultcodes[resultcode]
          ticket= data.find('thread').attr 'ticket'

          console.log h1('Resultcode '+resultcode+':'),code,description unless process.env.JASMINETEA_ID?
          console.log h1('Got:'),data.find('thread').attr() if options.verbose 

          viewer.comment= (text,optionAttrs={})->
            attrs= JSON.parse JSON.stringify {thread,ticket,postkey,mail,user_id,premium}
            attrs[key]= value for key,value of optionAttrs

            chat= cheerio '<chat/>'
            chat.attr attrs
            chat.text text

            # 不正な値が入れると受信されるが表示されない場合がある
            viewer.write chat.toString()+'\0'
            console.log 'Wrote',chat.toString()+'\0' if options.verbose
            
          viewer.emit 'handshaked' if resultcode is '0'
          viewer.emit 'error',resultcode if resultcode isnt '0'

        comments= data.find('chat')
        for comment in comments
          element= cheerio comment

          console.log element.toString() if options.verbose

          comment=
            attr: element.attr()
            text: element.text()
            usericon: api.usericonEmptyURL

          {anonymity,user_id}= comment.attr
          unless anonymity?
            comment.usericon= api.usericonURL+user_id.slice(0,2)+'/'+user_id+'.jpg' if user_id

          viewer.emit 'comment',comment

      if options.verbose
        ms= playerStatus.find('ms')
        port= ms.find('port').eq(0).text()
        addr= ms.find('addr').eq(0).text()

        console.log h1('Connect to'),"""
        http://#{addr}:#{port}/api/thread?thread=#{thread}&version=#{version}&res_from=#{res_from}
        """
        console.log h1('Or  static'),"""
        http://#{addr}:#{port-2725}/api/thread?thread=#{thread}&version=#{version}&res_from=#{res_from}
        """

        viewer.on 'timeout',-> console.log h1('Timeout'),arguments
        viewer.on 'lookup',-> console.log h1('Lookup'),arguments
        viewer.on 'error',-> console.log h1('Error'),arguments

      callback null,viewer
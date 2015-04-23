request= require 'request'
cheerio= require 'cheerio'

api= require '../api'

chalk= require 'chalk'
h1= chalk.underline.magenta

module.exports= (text,attrs,options={},callback=null)->
  callback?= (error)-> throw error if error
  return callback new Error 'Disconnected' unless @viewer?

  request
    url: api.comment+attrs.thread
    headers:
      Cookie: @get()
  ,(error,res,postkeyBody)=>
    [...,postkey]= postkeyBody.split '='
    return callback error if error?

    console.log h1('Got'),postkey,'by',postkeyBody if options.verbose

    chat= cheerio '<chat/>'
    chat.attr attrs
    chat.attr {postkey}
    chat.text text

    @viewer.write chat.toString()+'\0'
    console.log h1('Wrote'),chat.toString()+'\0' if options.verbose

    @viewer.on 'data',chatResult

  chunks= ''
  chatResult= (buffer)=>
    chunk= buffer.toString()
    chunks+= chunk
    return unless chunk.match /\u0000$/

    console.log chunks if options.verbose
    data= cheerio '<data>'+chunks+'</data>'
    chunks= ''

    status= data.find('chat_result').attr 'status'
    if status?.length
      console.log h1('Chat result'),status if options.verbose

      @viewer.removeListener 'data',chatResult
      
      return callback new Error ('Status is '+status) if status isnt '0'
      callback null,status if status isnt '0'

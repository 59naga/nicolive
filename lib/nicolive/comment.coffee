request= require 'request'
cheerio= require 'cheerio'

api= require '../api'

chalk= require 'chalk'
h1= chalk.underline.magenta

module.exports= (text,options,callback)->
  callback= options if typeof options is 'function'
  callback?= ((error)-> throw error if error)
  return callback new Error 'Disconnected' unless @viewer?

  request
    url: api.getPostKey+@attrs.thread
    headers:
      Cookie: @get()
  ,(error,res,postkeyBody)=>
    return callback error if error?
    [...,postkey]= postkeyBody.split '='

    console.log h1('Got'),postkey,'by',postkeyBody if options.verbose

    chat= cheerio '<chat/>'
    chat.attr JSON.parse JSON.stringify @attrs
    chat.attr {postkey}
    chat.text text.toString()

    @viewer.write chat.toString()+'\0'
    console.log h1('Wrote'),chat.toString()+'\0' if options.verbose
    @viewer.on 'data',chatResult

  chunks= ''
  chatResult= (buffer)=>
    chunk= buffer.toString()
    chunks+= chunk
    return unless chunk.match /\0$/

    console.log chunks if options.verbose
    data= cheerio '<data>'+chunks+'</data>'
    chunks= ''

    status= data.find('chat_result').attr 'status'
    if status.length
      console.log h1('Chat result'),status if options.verbose

      @viewer.removeListener 'data',chatResult
      
      if status is '0'
        callback null,status
      else
        callback new Error 'Status is '+status
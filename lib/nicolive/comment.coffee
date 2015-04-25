request= require 'request'
cheerio= require 'cheerio'

{url,status}= require '../api'
querystring= require 'querystring'

chalk= require 'chalk'
h1= chalk.underline.magenta

module.exports= (text,args...,callback)->
  options= args[0] ? {}
  callback= options if typeof options is 'function'
  callback?= ((error)-> throw error if error)
  return callback new Error 'Disconnected' unless @viewer?

  @getPostKey options,(error,postkey)=>
    return callback error if error?
    
    chat= cheerio '<chat/>'
    chat.attr JSON.parse JSON.stringify @attrs
    chat.attr {postkey}
    chat.attr 'mail',options.mail if options.mail?
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

    statusValue= data.find('chat_result').attr 'status'
    if statusValue.length
      console.log h1('Chat result'),statusValue if options.verbose

      @viewer.removeListener 'data',chatResult
      
      {code,description}= status[statusValue]
      error= new Error 'Status is '+statusValue+':'+code+' '+description if statusValue isnt '0'
      callback error,data.find('chat_result')

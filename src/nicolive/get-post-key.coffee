request= require 'request'
cheerio= require 'cheerio'

{url}= require '../api'
querystring= require 'querystring'

chalk= require 'chalk'
h1= chalk.underline.magenta

module.exports= (args...,callback)->
  return callback new Error 'Disconnected' unless @viewer?
  options= args[0] ? {}

  getPostKey= url.getPostKey+'?'+(
    querystring.stringify
      thread: @attrs.thread
      block_no: Math.floor((parseInt(@playerStatus.no)+1) / 100)
  )
  console.log h1('Request to '),getPostKey if options.verbose

  request
    url: getPostKey
    headers:
      Cookie: if options.cookie then options.cookie else @get()
  ,(error,res,postkeyBody)=>
    return callback error if error?
    [...,postkey]= postkeyBody.split '='

    console.log h1('Got'),postkey,'by',postkeyBody if options.verbose
    callback null,postkey

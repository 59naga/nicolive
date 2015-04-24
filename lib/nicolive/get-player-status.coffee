request= require 'request'
cheerio= require 'cheerio'

{url}= require '../api'

chalk= require 'chalk'
h1= chalk.underline.magenta

module.exports= (live_id,args...,callback)->
  options= args[0] ? {}
  
  console.log h1('Request to'),url.getPlayerStatus+live_id if options.verbose

  request
    url: url.getPlayerStatus+live_id
    headers:
      Cookie: @get()
  ,(error,res,body)=>
    errorMessage= cheerio(body).find('error code').text()
    return callback error if error?
    return callback errorMessage if errorMessage.length

    playerStatus= cheerio body
    ms= playerStatus.find('ms')
    port= ms.find('port').eq(0).text()
    addr= ms.find('addr').eq(0).text()

    thread= ms.find('thread').eq(0).text()
    version= '20061206'
    res_from= -1*options.from if options.from?
    res_from?= 0

    user_id= playerStatus.find('user_id').eq(0).text()
    premium= playerStatus.find('is_premium').eq(0).text()
    mail= '184'

    callback null,{
      port
      addr

      thread
      version
      res_from

      user_id
      premium
      mail
    }
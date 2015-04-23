cheerio= require 'cheerio'

module.exports= (body,options={})->
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

  {
    playerStatus

    port
    addr

    thread
    version
    res_from

    user_id
    premium
    mail
  }

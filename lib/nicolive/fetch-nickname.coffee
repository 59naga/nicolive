request= require 'request'
cheerio= require 'cheerio'

{url}= require '../api'

module.exports= (user_id,callback)-> 
  @knownNicknames?= {}
  if @knownNicknames[user_id]?
    process.nextTick =>
      callback null,@knownNicknames[user_id]
    return
  
  options=
    url: url.fetchNickname+user_id
  request options,(error,res,body)=>
    result= cheerio body
    return callback error if error?
    return callback result.find('error').text() if result.find('error').text().length

    @knownNicknames[user_id]= result.find('nickname').text()
    callback null,@knownNicknames[user_id]

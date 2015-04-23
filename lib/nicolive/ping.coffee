request= require 'request'
cheerio= require 'cheerio'

api= require '../api'

module.exports= (callback)-> 
  options=
    url: api.ping
    headers:
      Cookie: @get()
  request options,(error,res,body)=>
    return callback error if error?

    xml= cheerio body
    selector= 'error code'
    error= xml.find(selector).text() if xml.find(selector).text()

    callback error,not error?
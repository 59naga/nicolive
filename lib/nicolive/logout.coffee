request= require 'request'

api= require '../api'

module.exports= (callback)-> 
  options=
    url: api.logout
    headers:
      Cookie: @get()
    followRedirect: off
  request options,(error,res)=>
    return callback error if error?

    @destroy()

    callback null,res.statusCode
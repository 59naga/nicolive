request= require 'request'
cheerio= require 'cheerio'

api= require '../api'

module.exports= (id,pw,callback)-> 
  options=
    url: api.login
    form:
      mail_tel: id
      password: pw
  request.post options,(error,res,body)=>
    return callback error if error?

    cookies= res.headers['set-cookie']
    cookie= value for value in cookies when value.indexOf('user_session=user_session') is 0
    cookie?= ''
    cookieValue= cookie.slice 0,cookie.indexOf(';')+1
    return callback 'Invalid user' if cookieValue is ''

    @set cookieValue
    @save()

    callback null,cookieValue
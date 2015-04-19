BinaryCookies= require 'binary-cookies'
querystring= require 'querystring'
path= require 'path'

{HOME,HOMEPATH,USERPROFILE}= process.env
cookieHome= HOME or HOMEPATH or USERPROFILE
cookiePath= path.join cookieHome,'Library','Cookies','Cookies.binarycookies'

module.exports= (domain,callback)->
  binaryCookies= new BinaryCookies
  binaryCookies.parse cookiePath,(error,result)->
    return callback error if error?

    cookies= {}
    for cookie in result when cookie.url.indexOf(domain) > -1
      cookies[cookie.name]= cookie.value

    callback null,querystring.stringify cookies,'; ','='
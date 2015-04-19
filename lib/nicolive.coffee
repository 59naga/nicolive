Command= (require 'commander').Command
EventEmitter= (require 'events').EventEmitter

request= require 'request'
cheerio= require 'cheerio'

net= require 'net'
chalk= require 'chalk'
h1= chalk.underline.magenta
h2= chalk.underline.green

getLocalCookie= require './get-local-cookie'
resultcodes= (require './resultcodes').resultcodes

api=
  getplayerstatus: 'http://live.nicovideo.jp/api/getplayerstatus?v='

class Nicolive
  cli: (argv)->
    cli= new Command
    cli.version require('../package').version
    cli.usage '<URL> [options...]'
    cli.option '-v, --verbose','Output debug log.'
    cli.parse argv
    cli.help() if cli.args.length is 0

    @view cli.args[0],cli,(error,viewer)->
      throw error if error?

      chunks= ''
      chunk_id= null

      viewer.on 'timeout',-> console.log h1('Timeout'),arguments if cli.verbose
      viewer.on 'lookup',-> console.log h1('Lookup'),arguments if cli.verbose
      viewer.on 'error',-> console.log h1('Error'),arguments if cli.verbose
      viewer.on 'data',(chunk)->
        chunks+= chunk.toString()
        chunk_id= setTimeout ->
          data= cheerio '<data>'+chunks.toString()+'</data>'

          clearTimeout chunk_id
          chunks= ''

          resultcode= data.find('thread').attr 'resultcode'
          if resultcode?.length
            {code,description}= resultcodes[resultcode]

            console.log h1('resultcode='+resultcode),code,description if cli.verbose

          chats= data.find('chat')
          for chat in chats
            attr= cheerio(chat).attr()
            
            number= ('   '+(attr.no or '?')).slice(-3)
            text= cheerio(chat).text()
            console.log h2('Received',number+':'),text
        ,250

      if cli.verbose
        {port,addr,thread,version,res_from}= viewer.params

        console.log h1('Connect to'),"""
        http://#{addr}:#{port}/api/thread?thread=#{thread}&version=#{version}&res_from=#{res_from}
        """
        console.log h1('Or  static'),"""
        http://#{addr}:#{port-2725}/api/thread?thread=#{thread}&version=#{version}&res_from=#{res_from}
        """
  
  view: (url,args...,callback)->
    options= args[0] or {}

    getLocalCookie 'nicovideo.jp',(error,cookie)->
      id= url.match(/lv\d+/)?[0]
      url= api.getplayerstatus+id

      console.log h1('Request to'),url if options.verbose

      request
        url: url
        headers:
          Cookie: cookie
      ,(error,res,body)->
        result= cheerio body
        return callback error if error
        return callback body if result.find('error').text().length

        ms= result.find('ms')
        thread= ms.find('thread').text()
        port= ms.find('port').text()
        addr= ms.find('addr').text()
        
        version= '20061206'
        res_from= '-1000'

        viewer= net.connect port,addr
        viewer.on 'connect',->
          comment= cheerio '<thread />'
          comment.attr {thread,version,res_from}
          comment.options.xmlMode= on

          viewer.write comment.toString()+'\0'
          viewer.setEncoding 'utf-8'

        viewer.params= {url,port,addr,thread,version,res_from}

        callback null,viewer

module.exports= new Nicolive
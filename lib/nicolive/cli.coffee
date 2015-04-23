Command= (require 'commander').Command
readlineSync= require 'readline-sync'
cheerio= require 'cheerio'

chalk= require 'chalk'
h2= chalk.underline.green

module.exports= (argv)->
  cli= new Command
  cli
    .version require('../../package').version
    .usage '<liveID> [comment] [options...]'
    .option '-f, --from [number]','Get [0~1000] comment of past.',0
    .option '-v, --verbose','Output debug log.'
  cli
    .command 'logout'
    .action =>
      @logout ->
        console.log 'Destroied session.'
        process.exit 0

  cli.parse argv
  cli.help() if cli.args.length is 0
  return if 'logout' in cli.rawArgs

  @ping (error)=>
    if error
      console.log 'Please authorization.'
      id= readlineSync.question 'email: '
      pw= readlineSync.question 'password: ',noEchoBack:yes

      @login id,pw,(error)->
        return console.error error if error?
        console.log 'Authorized.'

        view()
    else
      view()

  view= =>
    @view cli.args[0],cli,(error,viewer)=>
      return console.error error if error?

      viewer.on 'handshaked',(attrs)=>
        @comment cli.args[1],attrs,cli if cli.args[1]
      viewer.on 'comment',(comment)->
        console.log h2('Received',(comment.attr.no ? '-')+':'),comment.text

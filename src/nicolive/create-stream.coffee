request= require 'request'
cheerio= require 'cheerio'

{url}= require '../api'

push= (data,name,value)->
  return unless name

  if name.slice(-2) is '[]'
    data[name]?= []
    data[name].push value
  else
    data[name]?= value

scrapeFormValues= (body,data={})->
  $= cheerio.load body
  $form= $('form[action=editstream]')

  for input in $form.find('input')
    $input= $(input)

    name= $input.attr('name')
    type= $input.attr('type')
    value= $input.val()
    checked= $input.attr('checked') is 'checked'

    switch type
      when 'button' then null

      when 'checkbox'
        push(data,name,value) if checked
      when 'radio'
        push(data,name,value) if checked

      else
        push(data,name,value)

  for select in $form.find('select')
    $select= $(select)

    name= $select.attr('name')
    value= $select.val()

    push(data,name,value)

  for textarea in $form.find('textarea')
    $textarea= $(textarea)

    name= $textarea.attr('name')
    value= $textarea.text()

    push(data,name,value)

  data

# 直前の配信情報を使用し、放送枠の取得を試みる
module.exports= (data={},callback)->
  cookie= @get()

  # 直前の配信情報が取得するには数分待つ必要がある（履歴に残るのが放送終了から数分後のため）
  # 未検証：あるいは?reuseid=\dで直接配信idを指定すれば回避可能かもしれない
  request
    url: url.editstream
    headers:
      Cookie: cookie
  ,(error,res,body)=>
    return callback error if error?

    $= cheerio.load body
    $error= $('.plus strong')
    return callback $error.text() if $error.text()

    data= scrapeFormValues body,data
    request
      method: 'POST'
      url: url.editstream
      formData: data
      headers:
        Cookie: cookie
    ,(error,res,body)=>
      return callback error if error?

      data= scrapeFormValues body
      data.kiyaku= 'true'

      request
        method: 'POST'
        url: url.editstream
        formData: data
        headers:
          Cookie: cookie
        followRedirect: true
      ,(error,res,body)->
        return callback error if error?

        $= cheerio.load body
        $error= $('#error_message')
        return callback $error.text().trim() if res.statusCode isnt 302

        uri= null
        for header in res.rawHeaders
          uri= 'http://live.nicovideo.jp/'+header if header.match /^watch\/\d+/

        callback null,uri

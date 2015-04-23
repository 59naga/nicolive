# ![node-nicolive][.svg] Node-nicolive [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Command line comment viewer

## Installation
```bash
$ npm install nicolive --global
$ nicolive -V
# 0.0.0-rc.4
```

## CLI
```bash
$ nicolive lv218499873 --verbose
# Please authorization.
email: your@email.address
password: ********
# Request to http://live.nicovideo.jp/api/getplayerstatus?v=lv218499873
# Connect to http://msg102.live.nicovideo.jp:2812/api/thread?thread=****&version=20061206&res_from=-1000
# Or  static http://msg102.live.nicovideo.jp:87/api/thread?thread=****&version=20061206&res_from=-1000
# Resultcode 0 FOUND コメント受信を開始します

^C
$ nicolive lv218499873 わこつ
# Resultcode 0 FOUND コメント受信を開始します
# Received   1: わこつ

^C
$ nicolive logout
# Exited
```

> [Nsen lv218499873][http://live.nicovideo.jp/watch/nsen/vocaloid]

## API
```bash
$ npm install nicolive --save
```

```js
var nicolive= require('nicolive');
nicolive.login('your@email.address','********',function(error,cookie){
  if(error) throw error;
  
  var url= 'http://live.nicovideo.jp/watch/lv218499873';
  var options= {};
  nicolive.view(url,options,function(error,viewer){
    if(error) throw error;

    viewer.on('handshaked',function(){
      viewer.comment('わこつ');
    });
    viewer.on('comment',function(comment){
      console.log(comment.text());// わこつ

      nicolive.logout(function(error){
        if(error) throw error;
        process.exit(0);
      });
    });
  });
});
```

## TEST
```bash
export LOGIN_ID=$(echo -n 'YOUR_MAILADDRESS' | base64)
export LOGIN_PW=$(echo -n 'YOUR_PASSWORD' | base64)
npm test
```

## 参考
* [niconicoのメッセージ(コメント)サーバーのタグや送り方の説明 2014-03-18 by hocomodashi][A]
* [node-nicovideo-api by Ragg-][B]

[A]: http://blog.goo.ne.jp/hocomodashi/e/3ef374ad09e79ed5c50f3584b3712d61
[B]: https://github.com/Ragg-/node-nicovideo-api

License
=========================
[MIT][License] by 59naga

[License]: http://59naga.mit-license.org/
[.svg]: https://cdn.rawgit.com/59naga/nicolive/master/.svg

[npm-image]: https://badge.fury.io/js/nicolive.svg
[npm]: https://npmjs.org/package/nicolive
[travis-image]: https://travis-ci.org/59naga/nicolive.svg?branch=master
[travis]: https://travis-ci.org/59naga/nicolive
[coveralls-image]: https://coveralls.io/repos/59naga/nicolive/badge.svg?branch=master
[coveralls]: https://coveralls.io/r/59naga/nicolive?branch=master
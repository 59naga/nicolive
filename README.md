# ![node-nicolive][.svg] Node-nicolive [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Command line comment viewer

## Installation
```bash
$ npm install nicolive --global
$ nicolive lv218499873 --verbose --from 1000
email: your@email.address
password: ********
# Request to http://live.nicovideo.jp/api/getplayerstatus?v=lv218499873
# Connect to http://msg102.live.nicovideo.jp:2812/api/thread?thread=****&version=20061206&res_from=-1000
# Or  static http://msg102.live.nicovideo.jp:87/api/thread?thread=****&version=20061206&res_from=-1000
# Resultcode 0 FOUND コメント受信を開始します
# Received   1: わこつ

^C
$ nicolive lv218499873
# Resultcode 0 FOUND コメント受信を開始します

^C
$ nicolive logout
# Exited
```

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

    viewer.on('handshaked',function(chunk){
      viewer.comment('わこつ');
    });
    viewer.on('comment',function(comment){
      console.log(comment.text());// わこつ
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
* [Safari のクッキーはどう保存されているのか？ 2009-08-18 by xcatsan][C]

[A]: http://blog.goo.ne.jp/hocomodashi/e/3ef374ad09e79ed5c50f3584b3712d61
[B]: https://github.com/Ragg-/node-nicovideo-api
[C]: http://xcatsan.blogspot.jp/2009/08/safari.html

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
# ![node-nicolive][.svg] Node-nicolive [![NPM version][npm-image]][npm] <!--[![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]-->

> Command line comment viewer

## Installation
```bash
$ npm install nicolive --global
$ nicolive http://live.nicovideo.jp/watch/lv********
# Received   1: わこつ
```

## Requirement
* node.js v0.10.36
* Mac OSX Yosemite 10.10.2
* Safari 8.0.4(Signed in nicovideo)

## API
```bash
$ npm install nicolive --save
```

```js
var nicolive= require('nicolive');
var url= 'http://live.nicovideo.jp/watch/lv********';
var options= {};
nicolive.view(url,options,function(error,viewer){
  if(error) throw error;

  viewer.on('data',function(chunk){
    console.log(chunk.toString());// chunk xml
  });
});
```

<!--
## 参考
* [niconicoのメッセージ(コメント)サーバーのタグや送り方の説明 2014-03-18 by hocomodashi][A]
* [node-nicovideo-api by Ragg-][B]
* [Safari のクッキーはどう保存されているのか？ 2009-08-18 by xcatsan][C]

[A]: http://blog.goo.ne.jp/hocomodashi/e/3ef374ad09e79ed5c50f3584b3712d61
[B]: https://github.com/Ragg-/node-nicovideo-api
[C]: http://xcatsan.blogspot.jp/2009/08/safari.html
-->

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
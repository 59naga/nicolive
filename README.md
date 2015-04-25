# ![node-nicolive][.svg] Node-nicolive [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Command line comment viewer

## Installation
```bash
$ npm install nicolive --global
$ nicolive -V
# 0.0.2
```

## CLI Usage
```bash
Usage: nicolive <liveID> [comment] [options...]

Commands:

  logout      Destroy session & Request to https://.../logout
  help [cmd]  display help for [cmd]

Options:

  -h, --help            output usage information
  -V, --version         output the version number
  -f, --from [number]   Get [0~1000] comment of past.
  -m, --mail [command]  Change [comment] command
  -v, --verbose         Output debug log.
```

```bash
$ nicolive nsen/hotaru --verbose
# Please authorization.
email: your@mail.address
password: ******
# Authorized.

# Request to http://live.nicovideo.jp/api/getplayerstatus/nsen/hotaru
# Player status { port: '2805',addr: 'omsg103.live.nicovideo.jp',thread: '1431971701',version: '20061206',res_from: -5,user_id: '47972775',premium: '0',comment_count: '25',mail: '184' }
# Connect to http://omsg103.live.nicovideo.jp:2805/api/thread?thread=1431971701&version=20061206&res_from=-5
# Or  static http://omsg103.live.nicovideo.jp:80/api/thread?thread=1431971701&version=20061206&res_from=-5
# Received raw <thread resultcode="0" thread="1431971701" last_res="2257" ticket="0xc998880" revision="1" server_time="1429935582"/><chat ...
# Resultcode 0 FOUND コメント受信を開始します
# Thread { resultcode: '0',thread: '1431971701',last_res: '2257',ticket: '0xc998880',revision: '1',server_time: '1429935582' }
# Chat { thread: '1431971701',ticket: '0xc998880',mail: '184',user_id: '47972775',premium: '0' }

^C
$ nicolive nsen/hotaru わこつ
# Resultcode 0 FOUND コメント受信を開始します
# Received 2262: わこつ

^C
$ nicolive logout
# Destroied session.
```

> [Nsen/vocaloid](http://live.nicovideo.jp/watch/nsen/vocaloid)

## API Usage
```bash
$ npm install nicolive --save
```

```js
var nicolive= require('nicolive');
nicolive.login('your@email.address','********',function(error,cookie){
  if(error) throw error;
  
  var live_id= 'lv218499873';
  nicolive.view(live_id,function(error,viewer){
    if(error) throw error;

    viewer.on('handshaked',function(){
      nicolive.comment('わこつ');
    });
    viewer.on('comment',function(comment){
      console.log(comment.text);// わこつ

      nicolive.logout(function(error){
        if(error) throw error;
        process.exit(0);
      });
    });
  });
});
```

[DEMO: atom-shell(Electron) Application](https://github.com/59naga/edgy-comment-viewer)

## TEST
```bash
export LOGIN_ID=$(echo -n 'YOUR_MAILADDRESS' | base64)
export LOGIN_PW=$(echo -n 'YOUR_PASSWORD' | base64)
npm test
```

## 参考
* [niconicoのメッセージ(コメント)サーバーのタグや送り方の説明 2014-03-18 by hocomodashi][A]
* [ニコニコAPIリストwiki][B]
* [node-nicovideo-api by Ragg-][X]

[A]: http://blog.goo.ne.jp/hocomodashi/e/3ef374ad09e79ed5c50f3584b3712d61
[B]: http://www59.atwiki.jp/nicoapi/
[X]: https://github.com/Ragg-/node-nicovideo-api

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

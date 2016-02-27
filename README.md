![icon](https://cdn.rawgit.com/59naga/nicolive/master/.svg) Node Nicolive
---

<p align="right">
  <a href="https://npmjs.org/package/nicolive">
    <img src="https://img.shields.io/npm/v/nicolive.svg?style=flat-square">
  </a>
  <a href="https://travis-ci.org/59naga/nicolive">
    <img src="http://img.shields.io/travis/59naga/nicolive.svg?style=flat-square">
  </a>
  <a href="https://coveralls.io/r/59naga/nicolive.io?branch=master">
    <img src="http://img.shields.io/coveralls/59naga/nicolive.io.svg?style=flat-square">
  </a>
</p>

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
# Player status { port: '2805',addr: 'omsg103.live.nicovideo.jp',title: 'Nsen - 蛍の光チャンネル',description: 'Nsenからの去り際に...',thread: '1431971701',version: '20061206',res_from: -5,user_id: '47972775',premium: '0',comment_count: '25',mail: '184' }
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
      nicolive.comment('わこつ',{mail:'184'});
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
* [Nodejsでニコ生のコメビュを作る - Qiita][C]
* [node-nicovideo-api by Ragg-][X]

[A]: http://blog.goo.ne.jp/hocomodashi/e/3ef374ad09e79ed5c50f3584b3712d61
[B]: http://www59.atwiki.jp/nicoapi/
[C]: http://qiita.com/59naga/items/0a22e30f019aaef683e4
[X]: https://github.com/Ragg-/node-nicovideo-api

License
---
[MIT](http://59naga.mit-license.org/)

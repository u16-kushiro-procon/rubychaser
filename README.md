#rubychaser

https://pypi.python.org/pypi/nullpobug.chaser をRubyで書いたものです．

一部機能に微妙な違いがあります．

##動作環境

* ruby 2.0.0-p353
* ruby 2.1.0
* ruby 2.1.1
* jruby 1.7.10

##簡単な使い方

動かずサーチだけ実行するCHaserクラスを作ってみます．

現状，オプションで指定するためには chaser/ 以下にファイルを作る必要があります．

```ruby
require_relative 'silent'

class MyCHaser < SilentCHaser
end
```

これを動かすには次のようにコマンドを実行します．

```bash
$ ruby main.rb --chaser=MyCHaser
```

`-p` オプションでポート番号を指定できます．他のオプションを確認するには，`--help` オプションを指定してください

```bash
$ ruby main.rb --help
```

詳しくはソースを読んでください

##GUI（開発中）
jrubyでgui.rbを起動するとポート番号やホストなどをGUIで設定できるようになります．  
今後は，履歴が残るようにする予定です．

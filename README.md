#rubychaser

https://pypi.python.org/pypi/nullpobug.chaser をRubyで書いたものです．

一部機能に微妙な違いがあります．

##動作環境

* ruby 2.0.0-p353

でしか試してません．

##簡単な使い方

動かずサーチだけ実行するCHaserクラスを作ってみます．

現状，オプションで指定するためには chaser/ 以下にファイルを作る必要があります．

```Ruby:my_chaser.rb
require_relative 'silent'

class MyCHaser < SilentCHaser
end
```

これを動かすには次のようにコマンドを実行します．

```Bash
$ ruby main.rb --chaser=MyCHaser
```

-p オプションでポート番号を指定できます．他のオプションを確認するには，--help オプションを指定してください

```Bash
$ ruby main.rb --help
```

詳しくはソースを読んでください

SpreadOSD
=========
SpreadOSD - 分散ストレージシステム


## 概要

SpreadOSDは、画像、音声、動画などの大きなデータを保存するのに適した、分散ストレージシステムです。
高い **拡張性**、**可用性**、**保守性** を持ち、優れた性能を発揮します。


### 拡張性

サーバを追加することで、ストレージの容量とI/Oスループットが向上します。
クラスタの構成はアプリケーションから隠蔽されるので、アプリケーションを停止したり設定しなおしたりすることなくサーバを追加することができます。


### 可用性

SpreadOSDはレプリケーションをサポートしています。数台のサーバが故障してもデータが失われることはありません。アプリケーションからのリクエストも通常通り処理されます。

SpreadOSDのレプリケーション戦略は、マルチマスタ･レプリケーションの組み合わせです。マスタサーバが故障した場合は、別のマスタサーバが最小のダウンタイムで即座にフェイルオーバーします。

また、SpreadOSDはデータセンタをまたいだレプリケーション（地理を考慮したレプリケーション）をサポートしています。それぞれのデータは複数のデータセンタに保存されるため、災害に備えることができます。


### 保守性

SpreadOSDは、すべてのデータサーバを一斉に制御するための管理ツールを同梱しています。また監視ツールを使ってサーバの負荷を可視化することもできます。
クラスタの規模が大きくなっても管理コストが増大しにくいと言いえます。


## もっと知るには

  - [アーキテクチャ](doc/arch.ja.md)
  - [インストール](doc/install.ja.md)
  - [システムの構築](doc/build.ja.md)
  - [運用](doc/operation.ja.md)
  - [障害対応](doc/fault.ja.md)
  - [コマンドラインリファレンス](doc/command.ja.md)
  - [プラグインリファレンス](doc/plugin.ja.md)
  - [APIリファレンス](doc/api.ja.md)
  - [改善とデバッグ](doc/devel.ja.md)
  - [HowTo](doc/howto.ja.md)
  - [FAQ](doc/faq.ja.md)


## HTMLドキュメントのmake

    $ gem install bluecloth
    $ make htmldoc
    $ open doc/index.html


## License

    Copyright (C) 2010-2011  FURUHASHI Sadayuki
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.
    
    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

See also NOTICE file.



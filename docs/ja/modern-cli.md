# モダンCLIツール

従来のUnixコマンドをより良いUXで置き換えるモダンなツール群。

## lazygit（エイリアス: `lg`）

gitコマンドのシンプルなターミナルUI。

```bash
lg          # 現在のリポジトリでlazygitを開く
lazygit     # フルコマンド
```

### キー操作

| キー | アクション |
|------|----------|
| `Space` | ファイルをステージ/アンステージ |
| `a` | 全ファイルをステージ |
| `c` | コミット |
| `p` | プッシュ |
| `P` | プル |
| `b` | ブランチ操作 |
| `m` | マージ |
| `r` | リベース |
| `s` | スタッシュ |
| `?` | 全キーバインドを表示 |
| `q` | 終了 |

### ワークフロー例

```bash
lg
# a（全てステージ）→ c（コミット）→ メッセージ入力 → Enter → p（プッシュ）
```

---

## dust（エイリアス: `du`）

ビジュアルバー付きのより直感的なディスク使用量アナライザー。

```bash
dust              # 現在のディレクトリ
dust ~/Downloads  # 特定のディレクトリ
dust -n 10        # 上位10件のみ
dust -s           # 見かけのサイズ
dust -r           # 逆順
dust -H           # 隠しファイルを表示
```

**出力例:**
```
  4.0G ┌── node_modules    │████████████████████ │  45%
  2.1G ├── .git            │██████████           │  24%
  1.5G ├── dist            │███████              │  17%
```

---

## duf（エイリアス: `df`）

美しい出力のより良いディスク空き容量ユーティリティ。

```bash
duf                     # マウントされた全ファイルシステムを表示
duf --only local        # ローカルのみ表示
duf /                   # 特定のパスを表示
duf --hide-mp "/System/*"  # 特定のファイルシステムを非表示
duf --json              # JSON出力
```

---

## procs（エイリアス: `ps`）

カラーとツリー表示を備えたモダンなps代替。

```bash
procs              # 全プロセスを表示
procs node         # プロセス名で検索
procs --tree       # プロセスツリーを表示
procs --watch      # ウォッチモード
procs --sortd cpu  # CPU使用率でソート
procs --sortd mem  # メモリ使用率でソート
procs --tcp        # ポートを使用しているプロセスを検索
procs --user $(whoami)  # ユーザーでフィルタ
```

---

## btm / bottom（エイリアス: `top`）

ターミナル用のグラフィカルなシステムモニター。

```bash
btm     # bottomを起動
top     # btmにエイリアス
```

### キー操作

| キー | アクション |
|------|----------|
| `e` | ウィジェットを拡大 |
| `h/l` | ウィジェット間を左右に移動 |
| `j/k` | 上下にスクロール |
| `/` | プロセスを検索 |
| `t` | ツリー表示を切り替え |
| `dd` | プロセスを終了 |
| `?` | ヘルプ |
| `q` | 終了 |

**ウィジェット:** CPU、メモリ、ネットワークI/O、ディスクI/O、温度、プロセスリスト

---

## tldr

実用的な例を含む、簡略化されたコミュニティ主導のmanページ。

```bash
tldr git        # コマンドのクイックヘルプを取得
tldr tar        # よくある例
tldr ffmpeg
tldr docker
tldr --update   # tldrキャッシュを更新
```

**出力例:**
```
tar
アーカイブユーティリティ。

- アーカイブを作成:
  tar cf target.tar file1 file2 file3

- アーカイブを展開:
  tar xf source.tar
```

---

## httpie（エイリアス: `http`）

ターミナル用のユーザーフレンドリーなHTTPクライアント。

```bash
# GETリクエスト
http httpbin.org/get

# クエリパラメータ付きGET
http httpbin.org/get name==john age==30

# JSONデータでPOST
http POST httpbin.org/post name=john age:=30

# フォームデータでPOST
http -f POST httpbin.org/post name=john

# カスタムヘッダー
http httpbin.org/get "Authorization: Bearer token123"

# ファイルをダウンロード
http --download example.com/file.zip

# リダイレクトをフォロー
http --follow example.com

# レスポンスボディ/ヘッダーのみ表示
http --body httpbin.org/get
http --headers httpbin.org/get
```

**JSON構文:**
- `name=value` - 文字列
- `age:=30` - 整数/真偽値/JSON
- `data:='{"key": "value"}'` - 生のJSON

---

## delta

git diff強化ツール - `git diff`、`git log`、`git show` で自動的に使用。

**機能:**
- シンタックスハイライト
- サイドバイサイド表示
- 行番号
- n/Nでナビゲート

```bash
git diff              # deltaは自動設定済み
# n = 次のファイル, N = 前のファイル

git diff --no-pager   # deltaを一時的に無効化
```


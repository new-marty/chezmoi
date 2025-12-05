# カスタムコマンド＆ツールリファレンス

## 目次

- [コアツール](#コアツール)
- [シェルコマンド](#シェルコマンド)
- [モダン CLI ツール](#モダンcliツール)
- [Git ツール](#gitツール)
- [開発ツール](#開発ツール)
- [キーバインド](#キーバインド)
- [エイリアス](#エイリアス)

---

## コアツール

この dotfiles 設定の基盤となるツール群。

### `chezmoi`

マルチマシン構成とテンプレートに対応した dotfile マネージャー。

```bash
# ソースからホームに変更を適用
chezmoi apply

# 変更内容を表示（適用前プレビュー）
chezmoi diff

# 管理対象ファイルを編集
chezmoi edit ~/.zshrc

# リモートリポジトリから更新
chezmoi update

# chezmoiソースディレクトリに移動
chezmoi cd

# 新しいファイルを管理対象に追加
chezmoi add ~/.some-config

# 管理対象ファイル一覧
chezmoi managed

# 外部変更後にファイルを再追加
chezmoi re-add ~/.zshrc

# テンプレート出力のテスト
chezmoi execute-template '{{ .chezmoi.hostname }}'
```

**エイリアス:**
| エイリアス | コマンド |
| ---------- | ---------------- |
| `cm` | `chezmoi` |
| `cma` | `chezmoi apply` |
| `cmd` | `chezmoi diff` |
| `cme` | `chezmoi edit` |
| `cmu` | `chezmoi update` |
| `cmcd` | `chezmoi cd` |

### `sheldon`

高速で設定可能な zsh プラグインマネージャー。

```bash
# プラグインをリロード
sheldon source

# インストール済みプラグイン一覧
sheldon list

# プラグインを追加
sheldon add plugin-name --github user/repo

# プラグインを削除
sheldon remove plugin-name

# 全プラグインを更新
sheldon lock --update
```

**設定ファイル:** `~/.config/sheldon/plugins.toml`

### `atuin`

同期、検索、統計機能を備えた魔法のようなシェル履歴。

```bash
# 履歴検索（Ctrl+Hでも可）
atuin search

# インタラクティブ検索
atuin search -i

# 統計を表示
atuin stats

# zshから履歴をインポート
atuin import zsh

# 履歴を同期（設定済みの場合）
atuin sync

# 現在のディレクトリの履歴を表示
atuin search --cwd .
```

**キーバインド:** `Ctrl+H` でインタラクティブ検索

### `zoxide`

使用パターンを学習するスマートな cd コマンド。

```bash
# ディレクトリにジャンプ（あいまい検索）
z projects        # "projects"の最も使用頻度の高いマッチに移動
z doc             # ~/Documents に移動するかも

# 複数キーワードでジャンプ
z local share     # ~/.local/share に移動

# インタラクティブ選択
zi                # fzfで選択

# ディレクトリを手動追加
zoxide add ~/important/path

# ディレクトリを削除
zoxide remove ~/old/path

# スコア付きエントリ一覧
zoxide query -l

# zの移動先を確認
zoxide query projects
```

**ヒント:**

- 短いキーワードを使う: `z Downloads` の代わりに `z dow`
- よく使うディレクトリほどスコアが高くなる

### `navi`

コマンドラインのインタラクティブチートシート。

```bash
# インタラクティブチートシートを開く
navi

# 特定のトピックを検索
navi --query git

# コマンドラインに追加（Ctrl+N）
# 部分的にコマンドを入力して Ctrl+N を押す
```

**キーバインド:** `Ctrl+N` で navi ウィジェットを開く

**カスタムチート:** `~/.config/navi/cheats/cheats.cheat`

### `fzf`

コマンドラインのファジーファインダー。

```bash
# 基本的なあいまい検索
fzf

# ファイルを見つけてエディタで開く
cursor $(fzf)

# 選択中にファイルをプレビュー
fzf --preview 'bat --color=always {}'

# 複数選択（Tabで選択）
fzf -m

# 特定のディレクトリで検索
find ~/Documents -type f | fzf
```

**統合済み:**

- Tab 補完（fzf-tab）
- コマンドテンプレート（Ctrl+G）
- スマートサジェスション（Ctrl+S）
- 履歴検索（peco/atuin 経由）

### `peco`

もう一つのインタラクティブフィルターツール（履歴に使用）。

```bash
# 入力をフィルタ
cat file.txt | peco

# 履歴検索（Ctrl+R）
history | peco
```

**キーバインド:**

- `Ctrl+R` - コマンド履歴を検索
- `Ctrl+U` - 最近のディレクトリにジャンプ

### `thefuck`

直前のコンソールコマンドを修正する。

```bash
# タイポの後
$ gut status
git: 'gut' is not a git command.

$ fuck
git status [enter/↑/↓/ctrl+c]
```

**使い方:** 失敗したコマンドの後に `fuck` と入力するだけ。

### `eza`

アイコンと git 統合を備えたモダンな ls 代替。

```bash
# 基本リスト（lsにエイリアス）
ls

# 長形式で全ファイル
ll          # ls -la

# gitステータス付き
lll         # ls -abghHliS --git

# ツリー表示
eza --tree --level=2

# 更新時刻でソート
eza -l --sort=modified
```

**エイリアス:**
| エイリアス | コマンド |
| ---------- | ---------------------- |
| `ls` | `eza --icons` |
| `ll` | `ls -la` |
| `la` | `ls -l` |
| `l1` | `ls -1` |
| `lll` | `ls -abghHliS --git` |

### `bat`

シンタックスハイライトと git 統合を備えた cat 代替。

```bash
# シンタックスハイライト付きでファイルを表示
bat file.py

# 行番号を表示
bat -n file.py

# 特定の行を表示
bat --line-range 10:20 file.py

# プレーン出力（装飾なし）
bat -p file.py

# diffを表示
bat --diff file.py
```

**注意:** この設定では `cat` は `ccat` にエイリアスされています。

### `ripgrep` (`rg`)

.gitignore を尊重する高速 grep 代替。

```bash
# パターンを検索
rg "pattern"

# 特定のファイルタイプで検索
rg "pattern" -t js

# 大文字小文字を区別しない
rg -i "pattern"

# ファイル名のみ表示
rg -l "pattern"

# 隠しファイルも検索
rg --hidden "pattern"

# パターンを含む/除外
rg "pattern" -g "*.js" -g "!node_modules"

# コンテキスト行を表示
rg -C 3 "pattern"       # 前後3行

# マッチ数をカウント
rg -c "pattern"

# 置換（プレビュー）
rg "old" --replace "new"
```

### `fd`

高速でユーザーフレンドリーな find 代替。

```bash
# 名前でファイルを検索
fd readme

# 拡張子で検索
fd -e js

# ディレクトリのみ
fd -t d

# ファイルのみ
fd -t f

# 隠しファイルを含める
fd -H pattern

# 結果にコマンドを実行
fd -e jpg -x convert {} {.}.png

# ディレクトリを除外
fd pattern -E node_modules
```

### `gh`

ターミナルから GitHub を操作する CLI。

```bash
# リポジトリをクローン
gh repo clone owner/repo

# 新しいリポジトリを作成
gh repo create my-project

# Issue を表示/作成
gh issue list
gh issue create

# PRを表示/作成
gh pr list
gh pr create
gh pr checkout 123

# PRをブラウザで表示
gh pr view --web

# CIステータスを確認
gh pr checks

# gistを作成
gh gist create file.txt
```

### `1Password CLI` (`op`)

コマンドラインから 1Password にアクセス。

```bash
# サインイン
op signin

# vault一覧
op vault list

# アイテムを取得
op item get "Item Name"

# 特定のフィールドを取得
op item get "Item Name" --fields password

# アイテムを作成
op item create --category login --title "New Login"

# chezmoiテンプレートでシークレットに使用
# {{ (onepasswordItemFields "Item" "Vault").FIELD.value }}
```

---

## シェルコマンド

### `mkcd`

ディレクトリを作成して移動。

```bash
mkcd my-new-project
# my-new-project/ を作成して移動
```

### `cdf`

fzf を使ってディレクトリを検索して移動。

```bash
cdf
# fzfが開いてディレクトリを検索・選択
```

### `fcat`

ヘッダー付きでファイル内容を再帰的に表示。

```bash
# ディレクトリ内のすべてのファイルを表示
fcat src/

# .gitignoreを考慮
fcat -i src/

# パターンでフィルタ
fcat -n '*.js' src/

# クリップボードにコピー
fcat -c src/main.js

# ファイルに保存
fcat -o output.txt lib/
```

オプション：

- `-i, --ignore-gitignore` - .gitignore パターンを考慮
- `-o, --output FILE` - ファイルに出力
- `-c, --clipboard` - クリップボードにコピー
- `-n, --name PATTERN` - ファイル名でフィルタ
- `-h, --help` - ヘルプを表示

### `ts2mp4`

TS 動画ファイルを MP4 に変換。

```bash
# 現在のディレクトリのすべてのTSファイルを変換
ts2mp4

# 出力ディレクトリを指定
ts2mp4 -o converted/

# 既存ファイルを上書き
ts2mp4 --force
```

オプション：

- `-o, --output DIR` - 出力ディレクトリ（デフォルト: mp4）
- `-f, --force` - 既存ファイルを上書き
- `-h, --help` - ヘルプを表示

### `brew`（ラッパー）

インタラクティブな Brewfile 管理機能付きの拡張 brew コマンド。

```bash
# パッケージをインストール
brew install ripgrep
# プロンプト: どのBrewfileに追加しますか？
#   > 全マシン共通 (common)
#     個人Macのみ
#     会社Macのみ
#     スキップ

# パッケージをアンインストール
brew uninstall ripgrep
# プロンプト: どのBrewfileから削除しますか？
```

### `help`

すべてのカスタムコマンドとキーバインドを表示。

```bash
help
```

---

## モダン CLI ツール

従来の Unix コマンドをより良い UX で置き換えるモダンなツール群。

### `lazygit`（エイリアス: `lg`）

git コマンドのシンプルなターミナル UI。git 操作を視覚的で直感的に。

```bash
# 現在のリポジトリでlazygitを開く
lg

# フルコマンド
lazygit
```

**lazygit のキー操作:**

| キー    | アクション                      |
| ------- | ------------------------------- |
| `Space` | ファイルをステージ/アンステージ |
| `a`     | 全ファイルをステージ            |
| `c`     | コミット                        |
| `p`     | プッシュ                        |
| `P`     | プル                            |
| `b`     | ブランチ操作                    |
| `m`     | マージ                          |
| `r`     | リベース                        |
| `s`     | スタッシュ                      |
| `?`     | 全キーバインドを表示            |
| `q`     | 終了                            |

**よくあるワークフロー:**

```bash
# 全てステージ、コミット、プッシュ
lg
# 操作: a（全てステージ）→ c（コミット）→ メッセージ入力 → Enter → p（プッシュ）
```

### `dust`（エイリアス: `du`）

ビジュアルバー付きのより直感的なディスク使用量アナライザー。

```bash
# 現在のディレクトリのディスク使用量を表示
dust

# 特定のディレクトリを表示
dust ~/Downloads

# 上位10件のみ表示
dust -n 10

# 見かけのサイズを表示（ディスク使用量ではなく）
dust -s

# 逆順（小さい順）
dust -r

# 隠しファイルを表示
dust -H
```

**出力例:**

```
  4.0G ┌── node_modules    │████████████████████ │  45%
  2.1G ├── .git            │██████████           │  24%
  1.5G ├── dist            │███████              │  17%
```

### `duf`（エイリアス: `df`）

美しい出力のより良いディスク空き容量ユーティリティ。

```bash
# マウントされた全ファイルシステムを表示
duf

# ローカルファイルシステムのみ表示
duf --only local

# 特定のパスを表示
duf /

# 特定のファイルシステムを非表示
duf --hide-mp "/System/*"

# JSON出力（スクリプト用）
duf --json
```

### `procs`（エイリアス: `ps`）

カラーとツリー表示を備えたモダンな ps 代替。

```bash
# 全プロセスを表示
procs

# プロセス名で検索
procs node

# プロセスツリーを表示
procs --tree

# ウォッチモード（topのような）
procs --watch

# CPU使用率でソート
procs --sortd cpu

# メモリ使用率でソート
procs --sortd mem

# 特定のカラムを表示
procs --insert user,cpu,mem
```

**便利なフィルタ:**

```bash
# ポートを使用しているプロセスを検索
procs --tcp

# ユーザーでプロセスを検索
procs --user $(whoami)
```

### `btm` / `bottom`（エイリアス: `top`）

ターミナル用のグラフィカルなシステムモニター。

```bash
# bottomを起動
btm

# エイリアスで
top
```

**bottom のキー操作:**

| キー  | アクション                 |
| ----- | -------------------------- |
| `e`   | 選択したウィジェットを拡大 |
| `h/l` | ウィジェット間を左右に移動 |
| `j/k` | 上下にスクロール           |
| `/`   | プロセスを検索             |
| `t`   | ツリー表示を切り替え       |
| `s`   | ソートメニュー             |
| `dd`  | 選択したプロセスを終了     |
| `?`   | ヘルプ                     |
| `q`   | 終了                       |

**ウィジェット:**

- CPU 使用率グラフ
- メモリ使用率グラフ
- ネットワーク I/O グラフ
- ディスク I/O グラフ
- 温度センサー
- プロセスリスト

### `tldr`

実用的な例を含む、簡略化されたコミュニティ主導の man ページ。

```bash
# コマンドのクイックヘルプを取得
tldr git

# よくある例
tldr tar
tldr ffmpeg
tldr docker

# tldrキャッシュを更新
tldr --update
```

**`tldr tar`の出力例:**

```
tar
アーカイブユーティリティ。

- アーカイブを作成:
  tar cf target.tar file1 file2 file3

- アーカイブを展開:
  tar xf source.tar

- gzip圧縮アーカイブを作成:
  tar czf target.tar.gz file1 file2
```

### `httpie`（エイリアス: `http`）

ターミナル用のユーザーフレンドリーな HTTP クライアント。

```bash
# シンプルなGETリクエスト
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

# レスポンスボディのみ表示
http --body httpbin.org/get

# ヘッダーのみ表示
http --headers httpbin.org/get
```

**JSON 構文:**

- `name=value` - 文字列
- `age:=30` - 整数/真偽値/JSON
- `data:='{"key": "value"}'` - 生の JSON

### `delta`（git diff 強化）

`git diff`、`git log`、`git show`などで自動的に使用される。

機能:

- シンタックスハイライト
- サイドバイサイド表示
- 行番号
- n/N でナビゲート

```bash
# deltaはgitに自動設定済み
git diff

# 変更をナビゲート
# n = 次のファイル, N = 前のファイル

# deltaを一時的に無効化
git diff --no-pager
```

---

## Git ツール

### Git エイリアス（gitconfig で定義）

```bash
# クイックステータス
git st          # 短いステータス

# きれいなログ
git lg          # カラー付きグラフログ
git lga         # 全ブランチのグラフログ

# ワークフローショートカット
git amend       # メッセージ編集なしでamend
git undo        # 最後のコミットをソフトリセット
git wip         # クイックWIPコミット
git please      # leaseオプション付きforce push（安全）

# クリーンアップ
git cleanup     # マージ済みブランチを削除

# 全エイリアスを表示
git aliases
```

### Lazygit vs Git CLI

| タスク                   | Git CLI                | Lazygit                    |
| ------------------------ | ---------------------- | -------------------------- |
| ファイルをステージ       | `git add file`         | ナビゲート + Space         |
| 全てステージ             | `git add .`            | `a`                        |
| コミット                 | `git commit -m "msg"`  | `c` + 入力                 |
| プッシュ                 | `git push`             | `p`                        |
| プル                     | `git pull`             | `P`                        |
| ブランチ切替             | `git switch branch`    | `b` + 選択                 |
| インタラクティブリベース | `git rebase -i HEAD~n` | コミット上で `r`           |
| コンフリクト解決         | 手動編集               | ビジュアルインターフェース |

---

## 開発ツール

### `direnv`

ディレクトリ毎の環境変数。ディレクトリに入ると自動的に`.envrc`をロード。

```bash
# .envrcファイルを作成
echo 'export API_KEY=secret123' > .envrc

# direnvにロードを許可
direnv allow

# .envrcを編集
direnv edit

# 手動でリロード
direnv reload

# 現在のディレクトリでdirenvをブロック
direnv deny
```

**よくある.envrc パターン:**

```bash
# .envファイルをロード
dotenv

# 特定のNodeバージョンを使用（nvmで）
use nvm 18

# 特定のPythonバージョンを使用（pyenvで）
use pyenv 3.11

# ローカルbinをPATHに追加
PATH_add bin

# 別のファイルをソース
source_env .env.local
```

### `fzf-tab`

fzf を使った強化された Tab 補完。通常通り Tab を押すだけ！

```bash
# プレビュー付きTab補完
cd <Tab>              # ディレクトリプレビューを表示
cat <Tab>             # ファイルプレビューを表示
git checkout <Tab>    # ブランチリストを表示
kill <Tab>            # プロセスリストを表示
```

### `nvm`

Node.js バージョンマネージャー（シェル起動高速化のため遅延ロード）。

```bash
# インストール済みバージョン一覧
nvm ls

# 利用可能なバージョン一覧
nvm ls-remote

# バージョンをインストール
nvm install 20

# バージョンを使用
nvm use 18

# デフォルトバージョンを設定
nvm alias default 20

# .nvmrcのバージョンを使用
nvm use
```

### `pyenv`

Python バージョンマネージャー。

```bash
# 利用可能なバージョン一覧
pyenv install --list

# バージョンをインストール
pyenv install 3.12

# グローバルバージョンを設定
pyenv global 3.12

# ローカルバージョンを設定（.python-versionを作成）
pyenv local 3.11

# インストール済みバージョン一覧
pyenv versions
```

---

## キーバインド

| キー     | 関数                     | 説明                               |
| -------- | ------------------------ | ---------------------------------- |
| `Ctrl+G` | `show_command_templates` | 定義済みコマンドテンプレートを表示 |
| `Ctrl+S` | `smart_command_suggest`  | コンテキストに応じた提案           |
| `Ctrl+F` | `show_frequent_commands` | よく使うコマンドを表示             |
| `Ctrl+N` | `navi_widget`            | navi チートシートを開く            |
| `Ctrl+R` | `peco-select-history`    | peco で履歴を検索                  |
| `Ctrl+H` | `_atuin_search_widget`   | atuin で履歴を検索                 |
| `Ctrl+U` | `peco-cdr`               | 最近のディレクトリにジャンプ       |
| `Tab`    | fzf-tab                  | プレビュー付き強化補完             |

---

## エイリアス

### Git エイリアス

| エイリアス | コマンド                               |
| ---------- | -------------------------------------- |
| `gs`       | `git status`                           |
| `gl`       | `git log --graph --pretty=format:...`  |
| `gls`      | `git log --stat --summary`             |
| `ga`       | `git add`                              |
| `br`       | `git branch --sort=-committerdate ...` |
| `gd`       | `git diff`                             |
| `gcm`      | `git commit -m`                        |
| `gca`      | `git commit --amend`                   |
| `gp`       | `git push origin head`                 |
| `sw`       | `git switch`                           |

### モダン CLI エイリアス

| エイリアス | コマンド  | 説明                   |
| ---------- | --------- | ---------------------- |
| `lg`       | `lazygit` | Git TUI                |
| `du`       | `dust`    | より良いディスク使用量 |
| `df`       | `duf`     | より良いディスク空き   |
| `ps`       | `procs`   | より良いプロセス表示   |
| `top`      | `btm`     | より良いシステムモニタ |

### ファイル＆ナビゲーションエイリアス

| エイリアス | コマンド             |
| ---------- | -------------------- |
| `ls`       | `eza --icons`        |
| `ll`       | `ls -la`             |
| `la`       | `ls -l`              |
| `l1`       | `ls -1`              |
| `lll`      | `ls -abghHliS --git` |
| `cat`      | `ccat`               |
| `diff`     | `colordiff -u`       |

### パッケージマネージャーエイリアス

| エイリアス | コマンド       |
| ---------- | -------------- |
| `pp`       | `pnpm`         |
| `pi`       | `pnpm install` |
| `pr`       | `pnpm run`     |
| `pd`       | `pnpm dev`     |
| `pu`       | `pnpm update`  |
| `pb`       | `pnpm build`   |

### ユーティリティエイリアス

| エイリアス | コマンド               |
| ---------- | ---------------------- |
| `rs`       | `exec $SHELL -l`       |
| `sz`       | `source ~/.zshrc`      |
| `c`        | `cursor`               |
| `p`        | `python3`              |
| `tf`       | `terraform`            |
| `dcu`      | `docker-compose up -d` |

### Chezmoi エイリアス

| エイリアス | コマンド         |
| ---------- | ---------------- |
| `cm`       | `chezmoi`        |
| `cma`      | `chezmoi apply`  |
| `cmd`      | `chezmoi diff`   |
| `cme`      | `chezmoi edit`   |
| `cmu`      | `chezmoi update` |
| `cmcd`     | `chezmoi cd`     |

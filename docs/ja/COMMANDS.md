# カスタムコマンド

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
# fzf が開いてディレクトリを検索・選択
```

### `fcat`

ヘッダー付きでファイル内容を再帰的に表示。

```bash
# ディレクトリ内のすべてのファイルを表示
fcat src/

# .gitignore を考慮
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
# 現在のディレクトリのすべての TS ファイルを変換
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
# プロンプト: どの Brewfile に追加しますか？
#   > 全マシン共通 (common)
#     個人 Mac のみ
#     会社 Mac のみ
#     スキップ

# パッケージをアンインストール
brew uninstall ripgrep
# プロンプト: どの Brewfile から削除しますか？
```

### `help`

すべてのカスタムコマンドとキーバインドを表示。

```bash
help
```

## キーバインド

| キー     | 関数                        | 説明                               |
| -------- | --------------------------- | ---------------------------------- |
| `Ctrl+G` | `show_command_templates`    | 定義済みコマンドテンプレートを表示 |
| `Ctrl+S` | `smart_command_suggest`     | コンテキストに応じた提案           |
| `Ctrl+F` | `show_frequent_commands`    | よく使うコマンドを表示             |
| `Ctrl+N` | `navi_widget`               | navi チートシートを開く            |
| `Ctrl+R` | `peco-select-history`       | peco で履歴を検索                  |
| `Ctrl+H` | `_atuin_search_widget`      | atuin で履歴を検索                 |
| `Ctrl+U` | `peco-cdr`                  | 最近のディレクトリにジャンプ       |

## Git エイリアス

| エイリアス | コマンド                                   |
| ---------- | ------------------------------------------ |
| `gs`       | `git status`                               |
| `gl`       | `git log --graph --pretty=format:...`      |
| `gls`      | `git log --stat --summary`                 |
| `ga`       | `git add`                                  |
| `br`       | `git branch --sort=-committerdate ...`     |
| `gd`       | `git diff`                                 |
| `gcm`      | `git commit -m`                            |
| `gca`      | `git commit --amend`                       |
| `gp`       | `git push origin head`                     |
| `sw`       | `git switch`                               |

## その他のエイリアス

| エイリアス | コマンド                 |
| ---------- | ------------------------ |
| `ls`       | `eza --icons`            |
| `ll`       | `ls -la`                 |
| `la`       | `ls -l`                  |
| `l1`       | `ls -1`                  |
| `lll`      | `ls -abghHliS --git`     |
| `cat`      | `ccat`                   |
| `diff`     | `colordiff -u`           |
| `rs`       | `exec $SHELL -l`         |
| `sz`       | `source ~/.zshrc`        |
| `c`        | `cursor`                 |
| `pp`       | `pnpm`                   |
| `pi`       | `pnpm install`           |
| `pr`       | `pnpm run`               |
| `pd`       | `pnpm dev`               |
| `pu`       | `pnpm update`            |
| `pb`       | `pnpm build`             |
| `dcu`      | `docker-compose up -d`   |
| `p`        | `python3`                |
| `tf`       | `terraform`              |


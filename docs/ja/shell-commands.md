# シェルコマンド

カスタムシェルコマンドと関数。

## mkcd

ディレクトリを作成して移動。

```bash
mkcd my-new-project
# my-new-project/ を作成して移動
```

---

## cdf

fzfを使ってディレクトリを検索して移動。

```bash
cdf
# fzfが開いてディレクトリを検索・選択
```

---

## fcat

ヘッダー付きでファイル内容を再帰的に表示。

```bash
fcat src/              # ディレクトリ内のすべてのファイルを表示
fcat -i src/           # .gitignoreを考慮
fcat -n '*.js' src/    # パターンでフィルタ
fcat -c src/main.js    # クリップボードにコピー
fcat -o output.txt lib/  # ファイルに保存
```

### オプション

| オプション | 説明 |
|-----------|------|
| `-i, --ignore-gitignore` | .gitignoreパターンを考慮 |
| `-o, --output FILE` | ファイルに出力 |
| `-c, --clipboard` | クリップボードにコピー |
| `-n, --name PATTERN` | ファイル名でフィルタ |
| `-h, --help` | ヘルプを表示 |

---

## ts2mp4

TS動画ファイルをMP4に変換。

```bash
ts2mp4               # 現在のディレクトリのすべてのTSファイルを変換
ts2mp4 -o converted/ # 出力ディレクトリを指定
ts2mp4 --force       # 既存ファイルを上書き
```

### オプション

| オプション | 説明 |
|-----------|------|
| `-o, --output DIR` | 出力ディレクトリ（デフォルト: mp4） |
| `-f, --force` | 既存ファイルを上書き |
| `-h, --help` | ヘルプを表示 |

---

## brew（ラッパー）

インタラクティブなBrewfile管理機能付きの拡張brewコマンド。

```bash
# Brewfileから全パッケージをインストール（引数なし）
brew install
# → 実行: brew bundle install --file=~/Brewfile

# 特定のパッケージをインストール
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

---

## help

すべてのカスタムコマンドとキーバインドを表示。

```bash
help
```

---

## keys

キーバインドのクイックリファレンスを表示。

```bash
keys
```

---

## docs

ドキュメントをCursorエディタで開く。

```bash
docs
```

---

## direnv

ディレクトリ毎の環境変数。ディレクトリに入ると自動的に`.envrc`をロード。

```bash
echo 'export API_KEY=secret123' > .envrc  # .envrcを作成
direnv allow      # direnvにロードを許可
direnv edit       # .envrcを編集
direnv reload     # 手動でリロード
direnv deny       # direnvをブロック
```

### よくある.envrcパターン

```bash
dotenv                    # .envファイルをロード
use nvm 18                # 特定のNodeバージョンを使用
use pyenv 3.11            # 特定のPythonバージョンを使用
PATH_add bin              # ローカルbinをPATHに追加
source_env .env.local     # 別のファイルをソース
```


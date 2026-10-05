# シェルコマンド

カスタムシェルコマンドと関数。

## update-dev

開発ツールを一括更新するメンテナンスコマンド。

```bash
update-dev           # すべて更新（brew, chezmoi, sheldon, atuin, mise）
update-dev --dry-run # 変更をプレビュー（実際には適用しない）
```

**更新対象:**
- Homebrew（update, upgrade, cleanup）
- Chezmoi（pull & apply）
- Sheldon プラグイン（lock --update）
- Atuin 履歴同期
- Mise ランタイムツール更新
- NPM グローバルパッケージ
- TLDR キャッシュ

---

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

このドキュメントを、`c` と同じ GUI エディタ（Cursor または VS Code）で開く。どちらもなければ Finder でドキュメントのフォルダを開く。

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
use mise                  # miseでバージョン管理
PATH_add bin              # ローカルbinをPATHに追加
source_env .env.local     # 別のファイルをソース
```


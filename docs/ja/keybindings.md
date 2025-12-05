# キーバインド

このdotfiles設定で設定されているすべてのキーボードショートカット。

## コマンドラインキーバインド

| キー | 関数 | 説明 |
| ---- | ---- | ---- |
| `Ctrl+G` | `show_command_templates` | 100+の定義済みコマンドテンプレートを表示 |
| `Ctrl+S` | `smart_command_suggest` | プロジェクトタイプに基づくコンテキスト対応サジェスト |
| `Ctrl+F` | `show_frequent_commands` | よく使うコマンドを表示 |
| `Ctrl+N` | `navi_widget` | naviインタラクティブチートシートを開く |
| `Ctrl+R` | `peco-select-history` | pecoでコマンド履歴を検索 |
| `Ctrl+H` | `_atuin_search_widget` | atuinで履歴を検索（より多機能） |
| `Ctrl+U` | `peco-cdr` | 最近訪問したディレクトリにジャンプ |
| `Tab` | fzf-tab | ファイルプレビュー付き強化補完 |

---

## 詳細

### Ctrl+G - コマンドテンプレート

よく使うコマンドのファジー検索可能なリストを表示:
- Gitコマンド
- Dockerコマンド
- パッケージマネージャーコマンド
- システムコマンド
- など...

### Ctrl+S - スマートサジェスト

プロジェクトタイプを検出して関連コマンドを提案:

| 検出ファイル | サジェスト |
|-------------|-----------|
| `package.json` | pnpm install, pnpm run dev など |
| `Dockerfile` | docker build, docker run |
| `docker-compose.yml` | docker-compose up/down/logs |
| `.git` | git status, add, commit, push |
| `Makefile` | make, make install, make clean |
| `requirements.txt` | pip install, venv |
| `go.mod` | go run, go build, go test |
| `Cargo.toml` | cargo run, cargo build, cargo test |

### Ctrl+F - よく使うコマンド

履歴から最も頻繁に使用する20コマンドを表示。

### Ctrl+N - Naviチートシート

以下のインタラクティブチートシート:
- git
- docker
- npm/pnpm
- terraform
- kubernetes
- システムコマンド
- カスタムチート

### Ctrl+R vs Ctrl+H

| 機能 | Ctrl+R (peco) | Ctrl+H (atuin) |
|------|---------------|----------------|
| インターフェース | シンプルなリスト | リッチなUI |
| 検索 | 基本的なファジー | フルテキスト + フィルタ |
| コンテキスト | なし | ディレクトリ対応 |
| 同期 | なし | オプションでクラウド同期 |

### Tab - fzf-tab

強化されたTab補完:
- ファイル/ディレクトリプレビューを表示
- ファジーマッチング
- すべてのコマンドで動作

```bash
cd <Tab>              # ディレクトリをプレビュー
cat <Tab>             # ファイルをプレビュー
git checkout <Tab>    # ブランチを表示
kill <Tab>            # プロセスを表示
```

---

## lazygitキーバインド

| キー | アクション |
|------|----------|
| `Space` | ステージ/アンステージ |
| `a` | 全てステージ |
| `c` | コミット |
| `p` | プッシュ |
| `P` | プル |
| `b` | ブランチ |
| `m` | マージ |
| `r` | リベース |
| `s` | スタッシュ |
| `?` | ヘルプ |
| `q` | 終了 |

---

## bottom (btm) キーバインド

| キー | アクション |
|------|----------|
| `e` | ウィジェットを拡大 |
| `h/l` | ウィジェット間を移動 |
| `j/k` | スクロール |
| `/` | 検索 |
| `t` | ツリー表示 |
| `dd` | プロセスを終了 |
| `?` | ヘルプ |
| `q` | 終了 |

---

## クイックリファレンスコマンド

ターミナルで `keys` と入力するとキーバインドを表示:

```bash
keys
```


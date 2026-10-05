# エイリアス

この dotfiles 設定の完全なエイリアスリファレンス。

## Git エイリアス

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
| `lg`       | `lazygit`（lazygit があるときだけ）    |

---

## モダン CLI エイリアス

下の表のエイリアスは、対応するツールがインストールされているときだけ設定される。シェルの起動時に確認するので、ツールがなければ元のコマンドがそのまま動く（`diff` だけは `diff -u` になる）。

| エイリアス | コマンド                           | 元コマンド | 説明                           |
| ---------- | ---------------------------------- | ---------- | ------------------------------ |
| `ls`       | `eza --icons=auto`                 | `ls`       | アイコン付きリスト             |
| `du`       | `dust`                             | `du`       | ビジュアルディスク使用量       |
| `df`       | `duf`                              | `df`       | 美しいディスク空き             |
| `ps`       | `procs`                            | `ps`       | モダンプロセス表示             |
| `top`      | `btm`                              | `top`      | グラフィカルシステムモニター   |
| `cat`      | `bat --style=plain --paging=never` | `cat`      | シンタックスハイライト付き cat |
| `catp`     | `bat`                              | -          | ページャと行番号付きの bat     |
| `diff`     | `colordiff -u`                     | `diff`     | カラー付き diff                |

---

## ファイル＆ナビゲーションエイリアス

| エイリアス | コマンド                           | 説明                                     |
| ---------- | ---------------------------------- | ---------------------------------------- |
| `ls`       | `eza --icons=auto`                 | アイコン付きリスト（eza があるとき）     |
| `ll`       | `ls -la`                           | 長形式、全ファイル                       |
| `la`       | `ls -l`                            | 長形式                                   |
| `l1`       | `ls -1`                            | 1 行に 1 ファイル                        |
| `lll`      | `eza -abghHliS --git --icons=auto` | git ステータス付き詳細（eza があるとき） |

---

## パッケージマネージャーエイリアス

| エイリアス | コマンド       | 説明                   |
| ---------- | -------------- | ---------------------- |
| `pp`       | `pnpm`         | pnpm                   |
| `pi`       | `pnpm install` | 依存関係をインストール |
| `pr`       | `pnpm run`     | スクリプトを実行       |
| `pd`       | `pnpm dev`     | 開発サーバーを起動     |
| `pu`       | `pnpm update`  | 依存関係を更新         |
| `pb`       | `pnpm build`   | プロジェクトをビルド   |

---

## ユーティリティエイリアス

| エイリアス | コマンド               | 説明                                    |
| ---------- | ---------------------- | --------------------------------------- |
| `rs`       | `exec zsh -l`          | シェルを再起動                          |
| `sz`       | `source ~/.zshrc`      | zshrc をリロード                        |
| `c`        | Cursor または VS Code  | GUI エディタを開く（下記参照）          |
| `p`        | `python3`              | Python 3                                |
| `tf`       | `terraform`            | Terraform                               |
| `dcud`     | `docker compose up -d` | Docker compose をバックグラウンドで起動 |
| `dcu`      | `docker compose up`    | Docker compose 起動                     |
| `dcd`      | `docker compose down`  | Docker compose 停止                     |

`c` が開くのは、git の `core.editor` と同じエディタだ。どちらを使うかは、chezmoi がファイルを生成するときに決まる。`~/.config/chezmoi/chezmoi.toml` の `optin` に `cursor` があり、`cursor` コマンドもあれば Cursor を使う。そうでなければ、`code` コマンドがあるときに VS Code を使う。どちらもなければ `c` は定義されない。Cursor や VS Code を後から入れたら、もう一度 `chezmoi apply` を実行する。

選ばれたエディタはシェル変数 `DOTFILES_GUI_EDITOR` に入る。特定のマシンだけ別のエディタにしたいときは、`~/.zshenv.local` でこの変数を設定するか、`~/.zshrc.local` で `c` を定義し直す。

---

## Chezmoi エイリアス

| エイリアス | コマンド         | 説明             |
| ---------- | ---------------- | ---------------- |
| `cm`       | `chezmoi`        | Chezmoi          |
| `cma`      | `chezmoi apply`  | 変更を適用       |
| `cmd`      | `chezmoi diff`   | diff を表示      |
| `cme`      | `chezmoi edit`   | ファイルを編集   |
| `cmu`      | `chezmoi update` | リモートから更新 |
| `cmcd`     | `chezmoi cd`     | ソースに移動     |

---

## ヘルプエイリアス

| エイリアス | コマンド             | 説明                         |
| ---------- | -------------------- | ---------------------------- |
| `help`     | `show_dotfiles_help` | 全コマンドを表示             |
| `keys`     | `show_keybindings`   | キーバインドを表示           |
| `docs`     | `open_dotfiles_docs` | ドキュメントをエディタで開く |

---

## キーバインド

| キー     | 機能                         |
| -------- | ---------------------------- |
| `Ctrl+G` | コマンドテンプレート         |
| `Ctrl+S` | スマート候補（コンテキスト） |
| `Ctrl+F` | よく使うコマンド             |
| `Ctrl+N` | Navi チートシート            |
| `Ctrl+R` | Peco 履歴検索                |
| `Ctrl+H` | Atuin 拡張履歴検索           |
| `Ctrl+U` | 最近のディレクトリ           |
| `Tab`    | fzf-tab 補完                 |

---

## メンテナンスエイリアス

| エイリアス   | コマンド | 説明                   |
| ------------ | -------- | ---------------------- |
| `update-dev` | (関数)   | 全開発ツールを一括更新 |

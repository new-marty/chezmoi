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
| `lg`       | `lazygit`                              |

---

## モダン CLI エイリアス

| エイリアス | コマンド       | 元コマンド | 説明                         |
| ---------- | -------------- | ---------- | ---------------------------- |
| `ls`       | `eza --icons`  | `ls`       | アイコン付きリスト           |
| `du`       | `dust`         | `du`       | ビジュアルディスク使用量     |
| `df`       | `duf`          | `df`       | 美しいディスク空き           |
| `ps`       | `procs`        | `ps`       | モダンプロセス表示           |
| `top`      | `btm`          | `top`      | グラフィカルシステムモニター |
| `cat`      | `ccat`         | `cat`      | カラー付き cat               |
| `diff`     | `colordiff -u` | `diff`     | カラー付き diff              |

---

## ファイル＆ナビゲーションエイリアス

| エイリアス | コマンド             | 説明                   |
| ---------- | -------------------- | ---------------------- |
| `ls`       | `eza --icons`        | アイコン付きリスト     |
| `ll`       | `ls -la`             | 長形式、全ファイル     |
| `la`       | `ls -l`              | 長形式                 |
| `l1`       | `ls -1`              | 1 行に 1 ファイル      |
| `lll`      | `ls -abghHliS --git` | git ステータス付き詳細 |

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

| エイリアス | コマンド               | 説明                  |
| ---------- | ---------------------- | --------------------- |
| `rs`       | `exec $SHELL -l`       | シェルを再起動        |
| `sz`       | `source ~/.zshrc`      | zshrc をリロード      |
| `c`        | `code`                 | VS Code エディタを開く |
| `p`        | `python3`              | Python 3              |
| `tf`       | `terraform`            | Terraform             |
| `dcu`      | `docker-compose up -d` | Docker compose 起動   |

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

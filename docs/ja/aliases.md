# エイリアス

この dotfiles が定義するエイリアスの一覧。任意のツールを呼ぶエイリアスは、シェルの起動時にそのツールがあるときだけ設定される。ツールがなければ元のコマンドがそのまま動く。自分のエイリアスは `~/.zshrc.local` に書く。そこで同じ名前を定義すれば、ここにあるものを置き換えられる。

## Git

| エイリアス | 実行するもの                                   |
| ---------- | ---------------------------------------------- |
| `gs`       | `git status`                                   |
| `gst`      | `git status --short --branch`                  |
| `ga`       | `git add`                                      |
| `gd`       | `git diff`                                     |
| `gdiff`    | `git diff --color-words`                       |
| `gcm`      | `git commit -m`                                |
| `gca`      | `git commit --amend`                           |
| `gp`       | `git push origin head`                         |
| `sw`       | `git switch`                                   |
| `br`       | `git branch`。新しい順、日付つき               |
| `gl`       | `git log --graph`。1 行の書式                  |
| `gls`      | `git log --stat --summary`                     |
| `glog`     | `git log --oneline --graph --decorate --all`   |
| `gtree`    | `git log --graph --full-history --all`。色つき |
| `lg`       | `lazygit`（入っているとき）                    |

git 自体にもエイリアス（`git st`、`git undo` など）がある。[Git](git.md) を参照。

## 標準コマンドの置き換え

| エイリアス | 実行するもの                       | 条件                     |
| ---------- | ---------------------------------- | ------------------------ |
| `ls`       | `eza --icons=auto`                 | eza があるとき           |
| `lll`      | `eza -abghHliS --git --icons=auto` | eza があるとき           |
| `cat`      | `bat --style=plain --paging=never` | bat があるとき           |
| `catp`     | `bat`（ページャと行番号つき）      | bat があるとき           |
| `du`       | `dust`                             | dust があるとき          |
| `df`       | `duf`                              | duf があるとき           |
| `ps`       | `procs`                            | procs があるとき         |
| `top`      | `btm`                              | btm があるとき           |
| `diff`     | `colordiff -u`。なければ `diff -u` | 常に                     |
| `ll`       | `ls -la`                           | 常に                     |
| `la`       | `ls -l`                            | 常に                     |
| `l1`       | `ls -1`                            | 常に                     |

`ll`、`la`、`l1` は `ls` を呼ぶので、eza があれば eza で表示される。

## chezmoi

| エイリアス | 実行するもの     |
| ---------- | ---------------- |
| `cm`       | `chezmoi`        |
| `cma`      | `chezmoi apply`  |
| `cmd`      | `chezmoi diff`   |
| `cme`      | `chezmoi edit`   |
| `cmu`      | `chezmoi update` |
| `cmcd`     | `chezmoi cd`     |

## tmux

| エイリアス | 実行するもの           |
| ---------- | ---------------------- |
| `t`        | `tmux`                 |
| `ta`       | `tmux attach -t`       |
| `tl`       | `tmux list-sessions`   |
| `tn`       | `tmux new-session -s`  |

## pnpm と Docker

| エイリアス | 実行するもの           |
| ---------- | ---------------------- |
| `pp`       | `pnpm`                 |
| `pi`       | `pnpm install`         |
| `pr`       | `pnpm run`             |
| `pd`       | `pnpm dev`             |
| `pu`       | `pnpm update`          |
| `pb`       | `pnpm build`           |
| `dcu`      | `docker compose up`    |
| `dcud`     | `docker compose up -d` |
| `dcd`      | `docker compose down`  |

## シェルとその他

| エイリアス | 実行するもの                               |
| ---------- | ------------------------------------------ |
| `rs`       | `exec zsh -l`（シェルを再起動する）        |
| `sz`       | `source ~/.zshrc`                          |
| `c`        | Cursor か VS Code（下を参照）              |
| `p`        | `python3`                                  |
| `tf`       | `terraform`                                |
| `yolo`     | `claude --dangerously-skip-permissions`    |
| `help`     | 自作コマンド、エイリアス、キーバインドの一覧を出す |
| `keys`     | キーバインドの一覧を出す                   |
| `docs`     | このドキュメントをエディタで開く           |

`c` は git の `core.editor` と同じエディタを開く。Cursor と VS Code のどちらにするかは、chezmoi がファイルを書くときに決まる。どちらも入っていなければ `c` は定義されない。決まり方と変え方は[導入と設定の詳細](setup.md#エディタの決まり方)にある。

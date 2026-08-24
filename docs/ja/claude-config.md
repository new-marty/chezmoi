# Claude Code の設定管理

Claude Code のユーザーレベル設定（`~/.claude`）は、この dotfiles リポジトリでは
**管理していない**。専用の git リポジトリ [`new-marty/dotclaude`](https://github.com/new-marty/dotclaude)
（private）に分離してある。

## なぜ chezmoi で管理しないのか

chezmoi は「source から target への一方向配布」を前提とする。source
（`~/.local/share/chezmoi/` 以下）を正とし、`chezmoi apply` が target
（ホームディレクトリ）を書き換える。target 側の変更を source に戻すには
`chezmoi re-add` を明示的に打つ必要がある。

`~/.claude` はこのモデルに合わない。Claude Code 自身が設定を書き換えるためである。

- `settings.json` — テーマ、モデル、`effortLevel` の変更、権限プロンプトで
  「常に許可」を選んだときの `permissions.allow` への追記
- `skills/` — 会話の中でスキルを作成・編集したとき
- `output-styles/` — 同上

つまり `chezmoi re-add` を打ち忘れるたびに source が古くなり、次の `chezmoi apply` で
新しい内容が古い内容に巻き戻る。実際にこの管理方式を採っていた期間に、
`statusline.sh` は source 側が57行の旧版のまま、実ファイルが173行に育つ状態になっていた。

一方、この用途で必要なのは双方向の同期と衝突解決で、それは git がそのまま提供する。
`git pull --rebase --autostash` はローカルの編集を退避してから取り込み、
戻せない場合は衝突として停止する。chezmoi の層を挟む理由がない。

## 役割分担

| 担当 | 範囲 |
| --- | --- |
| chezmoi | 新しいマシンで `~/.claude` を dotclaude リポジトリに接続する（初回のみ） |
| git | 日々の同期。Claude Code のフックが pull と push を自動実行する |

このリポジトリ側にあるのは `run_once_before_bootstrap-dotclaude.sh` の1本だけ。
`~/.claude` の中身には一切触れない。

## bootstrap スクリプト

`run_once_before_bootstrap-dotclaude.sh` は `~/.claude` をその場で git リポジトリ化する。
`git clone` を使わないのは、Claude Code のインストーラ（`run_once_install-claude-code.sh.tmpl`
が実行する `claude.ai/install.sh`）が `~/.claude/downloads/` などを先に作るため、
clone が「ディレクトリが空でない」として失敗するからである。

代わりに `git init` → `fetch` → `reset`（`--hard` なし）→ `checkout-index -a` を実行する。
この組み合わせは、そのマシンに既にあるファイルを上書きせず、無いファイルだけを
書き出す。ローカル版とリモート版が違う場合は `git status` に変更として現れ、
どちらを採るかは人が決める。

`run_once_` スクリプトは失敗すると完了として記録されないため、ネットワーク断などで
fetch に失敗しても次回の `chezmoi apply` で再実行される。

## 追跡対象を変えたいとき

`~/.claude/.gitignore` を編集する。このリポジトリ側の設定ではない。

`.gitignore` は既定ですべてを無視し、設定ファイルだけを明示的に許可する方式で
書いてある。追跡対象を増やすにはディレクトリごとに2行（`!name/` と `!name/**`）を足す。
詳細は `~/.claude/README.md` にある。

## この分離で変わったこと

以前は `private_dot_claude/` に `settings.json` と `statusline.sh` があり、
リポジトリ直下の `CLAUDE.md` が `~/CLAUDE.md` として配布されていた。後者は
Claude Code が親ディレクトリを遡って `CLAUDE.md` を探す仕様と組み合わさり、
ホーム以下のすべてのプロジェクトで dotfiles の説明が読み込まれる状態になっていた。
現在は `.chezmoiignore` で配布を止めてある。

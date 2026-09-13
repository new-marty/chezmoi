# Backlog

このリポジトリで着手待ち・未完了の作業を置く。1項目ずつ見出しで区切り、
何が残っているかと、なぜそうなっているかを、コードを読まなくても分かる形で書く。
終わったら項目ごと削除する（履歴は git が持っている）。

---

## `brew autoupdate` を launchd に読み込ませる

`brew autoupdate` の設定は完了しているが、**launchd への読み込みだけが未実行**。
このままでは自動更新は動かない。

実ターミナル（Ghostty など）で1行打つだけ。

```bash
launchctl load ~/Library/LaunchAgents/com.github.domt4.homebrew-autoupdate.plist
```

確認は次の2つ。`status` が "installed and running." になれば完了。

```bash
brew autoupdate status
brew autoupdate logs
```

### なぜ後回しにしたか

plist の `RunAtLoad` が `true` なので、**読み込んだ瞬間に1回目の更新が走る**。
その時点で未更新の cask に `cmux` が含まれており、cmux は作業セッションが動いている
端末アプリ。更新中に `/Applications/cmux.app` が差し替わるとセッションが落ちうるため、
実行タイミングを選べるよう保留した。cmux を使っていないときに実行すること。

### 設定済みの内容

```
brew autoupdate start --upgrade --immediate --ac-only --notify-on-error
```

- 間隔は24時間（86400秒）
- `--upgrade` — `brew update && brew upgrade --no-ask --formula -v && brew upgrade --no-ask --cask -v`
- `--ac-only` — AC 電源に繋がっていなければスキップ（実行スクリプト冒頭の `pmset -g ps` 判定）
- `--notify-on-error` — 失敗時のみ通知
- `--cleanup` は付けていない。更新直後に問題が出たとき Caskroom の旧版から戻せる
  余地を残すため。掃除は `just brew-cleanup` で手動
- `--greedy` は不要。Homebrew 6.x の `brew upgrade` は既定で `auto_updates` の cask も対象にする
- `--sudo` は不要。管理者権限を要求していた `session-manager-plugin` は削除済み

### 既知の注意点

`brew autoupdate start` コマンド自体は上流のバグでエラー終了する。

```
Error: undefined method 'quiet_system' for module Autoupdate
lib/autoupdate/start.rb:287
```

Homebrew 6.x で `quiet_system` が無くなったのが原因。
[issue #243](https://github.com/Homebrew/homebrew-autoupdate/issues/243) として報告済みで、
修正 [PR #244](https://github.com/Homebrew/homebrew-autoupdate/pull/244) は未マージ。
plist と実行スクリプトは生成された後に失敗するので、設定自体は完成している。
失敗するのは launchctl への読み込み1行だけ。タップが更新されれば
`brew autoupdate start` を打ち直すだけで済むようになる。

実行スクリプト（`~/Library/Application Support/com.github.domt4.homebrew-autoupdate/brew_autoupdate`）
の `PATH` は生成時のシェル環境を焼き込む。初回生成時にセッション固有の一時ディレクトリを
拾っていたため手で最小構成に書き換えてある。打ち直す場合は素のターミナルから実行すること。

---

## Orca で仕事用の Claude アカウントに切り替える手間を減らすか決める

Orca（複数のコーディングエージェントを worktree ごとに並列で動かすデスクトップアプリ）に
Claude アカウントを2つ登録してある。個人の `yumabuchi1998@gmail.com`（Claude Max 20x）と、
仕事の `work@example.com`（Starup Dev Team）。ホスト既定は個人にしてあり、仕事の
リポジトリ `~/starup/archaive-pj` で作業するときだけ切り替えて使う。

切り替えはステータスバーの Claude チップから手で行う。これを自動化するかどうかが未決。

### 先に確かめること

切り替えが **worktree ごとに1回で済むのか、エージェントを起動するたびに必要なのか**。
公式ドキュメントは「選んだ後に起動したセッションがそのアカウントを使う。起動済みの
セッションは再起動するまで元のアカウントのまま」と書いていて、Orca は
`~/Library/Application Support/Orca/codex-pane-accounts.json` にペイン単位で
`accountId` を記録している。1回で済むなら手動で十分。

確かめ方: 仕事リポジトリで worktree を1つ作り、仕事アカウントに切り替えてエージェントを
起動する。別の worktree に移動してから戻り、アカウントが保たれているかを見る。

### 自動化する場合の手段と代償

Orca の CLI には切り替えコマンドが無い。`orca agent-context --json` が返す全234コマンドを
調べたが、アカウント関連は `account add` と `account list` だけで setter が存在しない。

使えるのは Claude Code 側の `CLAUDE_CONFIG_DIR`。この環境変数は設定と認証をまとめて
分離する（空ディレクトリを指して起動すると、既存のログインに触れずに "Not logged in" を
返すことを確認済み）。仕事用の設定ディレクトリを用意すれば、起動コマンドで固定できる。

```bash
orca terminal create --worktree <archaive-pj の worktree> \
  --command 'CLAUDE_CONFIG_DIR=$HOME/.claude-work claude'
```

代償が2つある。

1. **Orca のアカウント管理が働かなくなる。** この経路で起動した Claude は Orca の管理下
   (`~/Library/Application Support/Orca/claude-accounts/<id>/auth`) を見ないので、
   ステータスバーの使用量とレート制限の残量はホスト側（個人）を映したままになる。
   アカウントを登録した目的が切り替え UI と使用量表示なので、それを捨てることになる。
2. **共有設定が二重になる。** `~/.claude` は new-marty/dotclaude で管理していて、
   `CLAUDE.md`、`settings.json`、`skills/`、`output-styles/`、`scripts/` が入っている。
   別の設定ディレクトリにはこれらが無いため、仕事セッションだけ指示もスキルも効かなくなる。
   symlink で繋げば解決するが、維持する対象が増える。

### 上流に要望を出す選択肢

`orca account use <id>` にあたる setter が1つあれば、代償なしに自動化できる。
リポジトリは https://github.com/stablyai/orca （MIT、活発に更新されている）。

---

## 1Password から Vaultwarden への移行

`docs/ja/migration-1password-to-vaultwarden-infisical.md` に8フェーズの移行計画がある
（483行）。パスワードと TOTP の移行、SSH Agent の切り替え、Git コミット署名、
chezmoi の age 暗号化までを扱う。

背景は `CLAUDE.md` の Password Manager Policy にある方針 — パスワードマネージャは
Vaultwarden/Bitwarden へ移行できる範囲の機能しか使わない。現状は 1Password を
使っているが、`op inject` や `op run` のような 1Password 固有の機能は避けている。

未着手。着手するならフェーズ0（単一マシンでの Bitwarden SSH Agent 検証）から。

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

## 1Password から Vaultwarden への移行

`docs/ja/migration-1password-to-vaultwarden-infisical.md` に8フェーズの移行計画がある
（483行）。パスワードと TOTP の移行、SSH Agent の切り替え、Git コミット署名、
chezmoi の age 暗号化までを扱う。

背景は `CLAUDE.md` の Password Manager Policy にある方針 — パスワードマネージャは
Vaultwarden/Bitwarden へ移行できる範囲の機能しか使わない。現状は 1Password を
使っているが、`op inject` や `op run` のような 1Password 固有の機能は避けている。

未着手。着手するならフェーズ0（単一マシンでの Bitwarden SSH Agent 検証）から。

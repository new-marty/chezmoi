# Backlog

このリポジトリで着手待ち・未完了の作業を置く。1項目ずつ見出しで区切り、
何が残っているかと、なぜそうなっているかを、コードを読まなくても分かる形で書く。
作業着手前に必ず起票し、終わったら項目ごと削除する（履歴は git が持っている）。

---

## [Todo] 会社の Mac を chezmoi に移す

リポジトリ側の準備は済んでいる。使えるものに合わせてスイッチを選び、足りないものは
ローカルのファイルで補う（手順は `docs/en/setup.md`）。残りはそのマシンでしかできない:

- chezmoi が使えるようになったら、手作業の `~/.dotfiles/` の中身をローカルのファイルへ
  移し、symlink を外してから apply する。プロンプトと配色を確かめる。
- 手作業版の Cursor の設定と steeef の修正を `chezmoi diff` と比べ、取り込むものを決める。

---

## [Todo] tmux と Vim のヒントを実際に使って見直す

ヒント（tmux の2段目、Neovim の which-key など）、チートシート（`cheatsheet/vim.html`、`cheatsheet/tmux.html`、
`just cheatsheet`）、VSCodeVim 用の設定は入れた。使い方は `docs/ja/tmux-vim.md`。
キーを実際に押しての確認は、まだ本人が手元でしていない。

- 実機で確かめる: Ghostty の tmux で `Opt+hjkl`、英数入力で `Space`+`v` と `Space`+`t`、ターミナルと
  VS Code での `Esc`（英数に戻るか）、tmux の2段目のヒントの幅。
- VSCodeVim を入れて使い始める（`just vscode-extensions`、`just vim-key-repeat`）。
- 2〜3週間後に、atuin の履歴で tmux と vim / nvim を開いた回数を見る。増えていなければ、
  何が止めているかを聞いて設定を直す（10か月で tmux 1回、vim 0回だったところから始めた）。

---

## [Todo] OrbStack が `~/.ssh/config` に書き足す行への対応

OrbStack は更新のたびに `~/.ssh/config` の先頭へ `Include ~/.orbstack/ssh/config` を
書き足す（OrbStack の issue #544、#489）。このマシンではその行を `~/.ssh/config.local`
に移してあるので、書き足されると `chezmoi diff` に差分が出て、次の apply で消える。
差分が出たら、共有の `private_dot_ssh/config` にその行を入れるか（ファイルが無ければ
ssh は無視する）、毎回 apply で戻すかを決める。

---

## 1Password から Vaultwarden への移行

下に8フェーズの移行計画がある。パスワードと TOTP の移行、SSH Agent の切り替え、
Git コミット署名、chezmoi の age 暗号化までを扱う。もとは PR #1 のブランチにあった
`docs/ja/migration-1password-to-vaultwarden-infisical.md` で、リポジトリを作り直した
ときにここへ移した。2026-02 時点の調査なので、ファイル名や行番号は今のコードと
ずれている（例: `Brewfile.common` はもう無い）。2026-10 時点では、コミット署名はやめていて、
1Password のエージェントの設定は公開リポジトリから外れ `~/.ssh/config.local` にだけある。
移行で触るのはそのローカルファイルになる。

背景は `CLAUDE.md` の Password Manager Policy にある方針 — パスワードマネージャは
Vaultwarden/Bitwarden へ移行できる範囲の機能しか使わない。現状は 1Password を
使っているが、`op inject` や `op run` のような 1Password 固有の機能は避けている。

未着手。着手するならフェーズ0（単一マシンでの Bitwarden SSH Agent 検証）から。

### 移行計画（PR #1 から転記）

#### 方針

| 用途 | 現在 (1Password) | 移行先 |
|------|------------------|--------|
| パスワード / TOTP | 1Password アプリ + ブラウザ拡張 | Vaultwarden (Bitwarden互換) |
| SSH Agent | 1Password SSH Agent (`IdentityAgent`) | Bitwarden SSH Agent (`SSH_AUTH_SOCK`) |
| Git Commit Signing | `op-ssh-sign` (1Password独自) | 標準 `ssh-keygen` (Bitwarden Agent経由) |
| chezmoi シークレット | `onepasswordItemFields` (op CLI) | chezmoi age 暗号化 (外部依存なし) |
| プロジェクト .env | `op run` | `bw` CLI or Infisical (後日判断) |

**Infisical は初期スコープから外す。** PostgreSQL + Redis + 複数コンテナは個人利用にはオーバーキル。
プロジェクト .env の管理は Vaultwarden 移行後に改めて判断する。

---

#### 現状の 1Password 依存箇所（コードベース調査結果）

##### テンプレート・設定ファイル

| ファイル | 依存内容 |
|---------|---------|
| `private_dot_ssh/config.tmpl:17,20` | `IdentityAgent` で 1Password SSH Agent ソケットを指定 |
| `dot_gitconfig.tmpl:143,145` | `op-ssh-sign` で SSH commit signing |
| `.chezmoitemplates/Brewfile.common:93-94` | `cask "1password"`, `cask "1password-cli"` |
| `dot_zshenv.tmpl:18` | `~/.secrets` を読み込む（`onepasswordItemFields` で生成される可能性） |
| `chezmoi.toml`（各マシン） | `[onepassword] command = "op"` |
| `justfile:23` | `apply-all` に「requires 1Password auth」コメント |

##### ドキュメント（計6ファイル）

`README.md`, `CLAUDE.md`, `docs/en/ssh-setup.md`, `docs/en/core-tools.md`, `docs/ja/core-tools.md`, `docs/ja/archive/COMMANDS.md`, `dot_zsh/alias.zsh`

##### SSH Agent の現状

| マシン | SSH Agent の使い方 |
|--------|------------------|
| Personal Mac (github.com) | `IdentityAgent none` — ローカルキー (`id_ed25519_macbook`) |
| Personal Mac (その他) | 1Password SSH Agent |
| Work Mac | 1Password SSH Agent |
| Ubuntu | 1Password SSH Agent 完全依存 |
| Unraid (ヘッドレス) | SSH ターゲット（Agent不要） |

---

#### Phase 0: スパイク — Bitwarden SSH Agent 検証（30分）

**目的**: 全面移行を決定する前に、最もリスクの高い部分を1台で検証する。

##### やること

1. **Personal Mac に Bitwarden デスクトップアプリをインストール**
   ```bash
   brew install --cask bitwarden
   ```
   > `cask` 版 (.dmg) を使う。App Store 版はソケットパスが異なり、サンドボックス制限で問題が報告されている。

2. **Bitwarden SSH Agent を有効化**
   - Settings → SSH Agent → Enable

3. **ソケットパスを確認**
   ```bash
   # cask版の期待パス
   ls -la ~/.bitwarden-ssh-agent.sock

   # App Store版の場合はこっち（使わない）
   # ~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
   ```

4. **SSH 接続テスト**
   ```bash
   # 一時的に SSH_AUTH_SOCK を切り替えてテスト
   SSH_AUTH_SOCK=~/.bitwarden-ssh-agent.sock ssh -T git@github.com
   ```

5. **Git commit signing テスト**
   ```bash
   # op-ssh-sign なしで署名できるか確認
   SSH_AUTH_SOCK=~/.bitwarden-ssh-agent.sock \
     git -c gpg.ssh.program="" commit --allow-empty -m "test signing"
   git log --show-signature -1
   ```

##### GO / NO-GO 判断

| 結果 | 判断 |
|------|------|
| SSH接続 + git signing 両方OK | → Phase 1 へ進む |
| SSH接続のみOK、signing失敗 | → signing はローカルキー運用に変更して Phase 1 へ |
| SSH接続も不安定 | → Bitwarden SSH Agent は使わず、ローカルキー運用に切り替え。Vaultwarden はパスワード管理のみ |

---

#### Phase 1: Vaultwarden セットアップ on Unraid（1-2時間）

##### docker-compose.yml

```yaml
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      DOMAIN: "https://vaultwarden.<tailnet>.ts.net"
      ADMIN_TOKEN: "<argon2-hashed-token>"
      SIGNUPS_ALLOWED: "false"
      INVITATIONS_ALLOWED: "false"
      WEBSOCKET_ENABLED: "true"
    volumes:
      - ./vw-data:/data
    ports:
      - "8080:80"
```

##### やること

1. Unraid に docker-compose でデプロイ
2. Tailscale 経由でアクセス（`tailscale serve --bg 8080`）
   - 外部公開しない。Tailnet 内のみ
3. HTTPS 設定（Tailscale cert or Caddy reverse proxy）
4. 管理者アカウント作成
   - `ADMIN_TOKEN` は argon2 ハッシュ推奨: `vaultwarden hash --preset owasp`
   - 管理画面で新規登録を無効化
5. **バックアップ設定**（重要）
   - SQLite DB (`/data/db.sqlite3`) の自動バックアップ
   - Unraid の Appdata Backup プラグイン or cron
   - バックアップ先: Unraid の別ディスク + クラウド（暗号化）
   - **Vaultwarden が落ちた時のために、Bitwarden クライアントのオフラインキャッシュに依存する期間がある**ことを認識しておく

##### 完了条件

- [ ] Tailscale 経由で Web UI アクセス成功
- [ ] HTTPS 接続確認
- [ ] 管理者ログイン成功
- [ ] バックアップジョブ設定・テスト完了

---

#### Phase 2: パスワード + TOTP 移行（30分）

##### ⚠️ 移行前に必ずやること

**TOTP（2FA）を使っている全サービスのリカバリーコードを事前に保存する。**
移行時に TOTP シードが欠落すると、アカウントにアクセスできなくなる。

##### やること

1. **1Password からエクスポート**
   - 1Password アプリ → File → Export → **1PUX 形式**
   - ⚠️ エクスポートファイルは暗号化されていない。RAM disk か暗号化ボリューム上で作業し、完了後すぐ削除
2. **Vaultwarden にインポート**
   - Web UI → Tools → Import Data → 1Password (1pux)
3. **インポート結果を検証**
   - アイテム数が一致するか
   - TOTP が正しくインポートされたか（2-3サービスで実際にログインテスト）
   - セキュアノート・カスタムフィールドの内容が正しいか
4. **ブラウザ拡張を切り替え**
   - Chrome / Safari: Bitwarden 拡張インストール
   - Self-hosted URL を設定（`https://vaultwarden.<tailnet>.ts.net`）
   - 1Password 拡張は無効化（まだ削除しない）
5. **モバイルアプリ切り替え**
   - iOS: Bitwarden アプリ → Self-hosted URL を設定

##### 完了条件

- [ ] 全アイテムのインポート確認（数の一致）
- [ ] TOTP が 2-3 サービスで動作確認
- [ ] ブラウザ拡張で自動入力が動作

---

#### Phase 3: chezmoi age 暗号化セットアップ（30分）

**1Password テンプレート関数 (`onepasswordItemFields`) を chezmoi のネイティブ age 暗号化で置き換える。**

`bw` CLI は `bw unlock` → `BW_SESSION` 環境変数の管理が必要で、`chezmoi apply` のたびにセッション管理が発生する。
age 暗号化はローカルキーのみで動作し、ネットワーク不要・認証フロー不要。

##### やること

1. **age キーペア生成**
   ```bash
   mkdir -p ~/.config/chezmoi
   chezmoi age-keygen --output ~/.config/chezmoi/key.txt
   # 出力される public key をメモ: age1xxxxxxx...
   ```

2. **chezmoi.toml に age 設定を追加**
   ```toml
   encryption = "age"
   [age]
       identity = "~/.config/chezmoi/key.txt"
       recipient = "age1xxxxxxx..."
   ```

3. **既存のシークレットを age 暗号化ファイルに変換**
   ```bash
   # 現在の ~/.secrets の内容を確認
   cat ~/.secrets

   # age 暗号化で chezmoi に追加
   chezmoi add --encrypt ~/.secrets
   # → encrypted_dot_secrets.age がソースディレクトリに作成される
   ```

4. **`[onepassword]` セクションを chezmoi.toml から削除**

5. **age キーを他のマシンにコピー**
   - 安全な方法で転送（`scp`, Bitwarden のセキュアノート等）
   - 各マシンの `~/.config/chezmoi/key.txt` に配置

##### chezmoi テンプレートの変更

```diff
 # chezmoi.toml
+encryption = "age"
+[age]
+    identity = "~/.config/chezmoi/key.txt"
+    recipient = "age1xxxxxxx..."
+
-[onepassword]
-    command = "op"
```

`onepasswordItemFields` を使ったテンプレート参照は不要になる。
`~/.secrets` ファイル自体が age 暗号化されてソースディレクトリに格納され、`chezmoi apply` 時に自動復号される。

##### 完了条件

- [ ] `chezmoi apply --dry-run -v` でエラーなし
- [ ] `~/.secrets` が正しく復号・配置される
- [ ] `op` CLI なしで `chezmoi apply` が成功

---

#### Phase 4: SSH + Git Signing 移行（1時間）

**Phase 0 のスパイク結果に基づいて実施。**

##### アプローチの変更点

**現在**: `IdentityAgent` で SSH config にソケットパスをハードコード
**移行後**: `SSH_AUTH_SOCK` 環境変数で設定（Bitwarden 推奨方式）

`SSH_AUTH_SOCK` を使う理由:
- `ssh-keygen` (git signing) は `SSH_AUTH_SOCK` を参照する。`IdentityAgent` は SSH 接続のみ
- 1つの設定で SSH 接続と git signing の両方をカバーできる
- `IdentityAgent` は例外（`none` 等）にのみ使用

##### 変更するファイル

###### 4-1. `dot_zshenv.tmpl` — SSH_AUTH_SOCK 設定を追加

```diff
+# Bitwarden SSH Agent
+{{- if eq .chezmoi.os "darwin" }}
+export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
+{{- else if eq .chezmoi.os "linux" }}
+export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
+{{- end }}
```

> macOS cask 版と Linux 標準インストール版はどちらも `~/.bitwarden-ssh-agent.sock`。
> App Store 版を使う場合は `~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock`。
> カスタムパスは `BITWARDEN_SSH_AUTH_SOCK` 環境変数で上書き可能。

###### 4-2. `private_dot_ssh/config.tmpl` — IdentityAgent を削除

```diff
 # --- SSH Agent Configuration (All Hosts) ---
 Host *
-{{- if eq .chezmoi.os "darwin" }}
-    # 1Password SSH Agent socket (macOS)
-    IdentityAgent ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
-{{- else if eq .chezmoi.os "linux" }}
-    # 1Password SSH Agent socket (Linux)
-    IdentityAgent ~/.1password/agent.sock
-{{- end }}
+    # SSH Agent は SSH_AUTH_SOCK 環境変数で設定 (dot_zshenv.tmpl)

     # Connection stability
     ServerAliveInterval 60
```

> `IdentityAgent none` (Personal Mac の github.com) はそのまま残す。

###### 4-3. `dot_gitconfig.tmpl` — op-ssh-sign を削除

```diff
-{{ if .ssh_signing_key }}
-# SSH commit signing with 1Password
+{{ if .ssh_signing_key }}
+# SSH commit signing (via Bitwarden SSH Agent / SSH_AUTH_SOCK)
 [gpg]
     format = ssh

 [gpg "ssh"]
-{{- if eq .chezmoi.os "darwin" }}
-    program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
-{{- else if eq .chezmoi.os "linux" }}
-    program = "/opt/1Password/op-ssh-sign"
-{{- end }}
     allowedSignersFile = ~/.ssh/allowed_signers
 {{ end }}
```

> `gpg.ssh.program` を削除すると、git は標準の `ssh-keygen` を使用する。
> `ssh-keygen` は `SSH_AUTH_SOCK` 経由で Bitwarden SSH Agent に署名を要求する。

##### テスト

```bash
# SSH 接続
ssh -T git@github.com
ssh debian
ssh unraid
ssh mac-mini

# Git signing
git commit --allow-empty -m "test bitwarden signing"
git log --show-signature -1

# chezmoi
chezmoi apply --dry-run -v
```

##### 完了条件

- [ ] 全マシンで SSH 接続成功
- [ ] Git commit signing 成功（`op-ssh-sign` なし）
- [ ] `chezmoi apply` 成功

---

#### Phase 5: Brewfile + ドキュメント更新（30分）

##### Brewfile 変更 (`.chezmoitemplates/Brewfile.common`)

```diff
-cask "1password"
-cask "1password-cli"
+cask "bitwarden"
```

##### justfile 変更

```diff
-# Apply with secrets (requires 1Password auth)
+# Apply with secrets (requires age key)
 apply-all:
     chezmoi apply
```

##### ドキュメント更新対象

| ファイル | 変更内容 |
|---------|---------|
| `README.md` | 1Password → Vaultwarden/Bitwarden に書き換え、chezmoi.toml 例更新 |
| `CLAUDE.md` | `onepasswordItemFields` → age 暗号化の説明に更新 |
| `docs/en/ssh-setup.md` | Bitwarden SSH Agent ベースに全面書き換え |
| `docs/en/core-tools.md` | op CLI → bw CLI |
| `docs/ja/core-tools.md` | 同上 |
| `dot_zsh/alias.zsh` | `op` の説明を `bw` に更新 |

##### 完了条件

- [ ] 全ドキュメントから 1Password 参照を削除
- [ ] `chezmoi apply --dry-run -v` でエラーなし

---

#### Phase 6: プロジェクト .env 管理（判断ポイント）

ここで `op run` を使っていたプロジェクトの .env 管理方法を決める。

##### 選択肢

| 方法 | 複雑度 | 向いてるケース |
|------|--------|--------------|
| **A: `.env` ファイル直置き** | 低 | プロジェクト数が少ない、ローカル開発のみ |
| **B: `bw` CLI** | 中 | プロジェクト数が少ない、CI/CD でも使いたい |
| **C: Infisical セルフホスト** | 高 | プロジェクト数が多い、チーム開発、環境ごとの管理が必要 |

##### 判断基準

- `op run` を使っているプロジェクトが **3個以下** → A or B で十分
- **4個以上** + CI/CD で使う → C (Infisical) を検討
- Infisical を立てる場合は **別の移行計画** として切り出す

##### 将来的な Infisical 導入について

現時点では age 暗号化 + `bw` CLI で十分だが、ホームラボの拡大に伴い
シークレットマネージャーが必要になる可能性がある。以下のタイミングで Infisical 導入を再検討:

- Unraid 上のコンテナが増え、`.env` の手動管理が煩雑になったとき
- 複数サービス間でシークレットを共有する必要が出たとき
- CI/CD パイプラインからシークレットを動的に取得したいとき
- シークレットのローテーション（定期更新）を自動化したいとき

Infisical は Unraid の docker-compose で Vaultwarden と並べて立てられるので、
この移行が完了した後にいつでも追加可能。

---

#### Phase 7: 検証期間（2週間）

##### やること

1. **1Password は解約せず並行運用**
   - 万が一の場合に戻せる状態をキープ
2. **日常使いは全部 Vaultwarden**
3. **チェックリスト**（2週間かけて確認）
   - [ ] パスワード自動入力が問題なく動作
   - [ ] TOTP が全サービスで動作
   - [ ] SSH 接続が全マシンで安定
   - [ ] Git commit signing が問題なし
   - [ ] `chezmoi apply` が全マシンで成功（age 暗号化）
   - [ ] Vaultwarden のバックアップが正常実行（1回以上リストアテスト）
   - [ ] Bitwarden アプリ再起動後も SSH Agent が復帰する
   - [ ] macOS リブート後も `SSH_AUTH_SOCK` が有効

---

#### Phase 8: クリーンアップ

1. **1Password データ削除 + サブスク解約**
2. **各マシンからアンインストール**
   ```bash
   brew uninstall --cask 1password
   brew uninstall --cask 1password-cli
   ```
3. **残骸削除**: `~/.config/op/`, `~/.op/`
4. **chezmoi リポジトリの最終コミット** — 1Password 関連コメント最終クリーンアップ

---

#### リスク

##### 高

| リスク | 影響 | 対策 |
|--------|------|------|
| TOTP 移行漏れ | 2FA ロックアウト | **Phase 2 前に全サービスのリカバリーコードを保存** |
| Vaultwarden 障害 | 全パスワードアクセス不能 | Bitwarden クライアントのオフラインキャッシュ + 定期バックアップ + 定期的にエクスポート保存 |

##### 中

| リスク | 影響 | 対策 |
|--------|------|------|
| Bitwarden SSH Agent が不安定 | SSH/signing 失敗 | Phase 0 スパイクで事前検証。ダメならローカルキー運用に切り替え |
| `bw` CLI のセッション管理が面倒 | DX 低下 | chezmoi secrets は age で解決済み。`bw` CLI は .env 管理のみ |
| age キーの紛失 | chezmoi secrets 復号不能 | age キーを Bitwarden のセキュアノートにバックアップ |

##### 低

| リスク | 影響 | 対策 |
|--------|------|------|
| Bitwarden ブラウザ拡張の UX の違い | 慣れるまで効率低下 | 1-2週間で解消 |
| Bitwarden SSH Agent ソケットパスの変更（アップデート時） | SSH 接続不可 | `BITWARDEN_SSH_AUTH_SOCK` でカスタムパス指定可能 |

---

#### ロールバック手順

Phase 8 実行前であれば完全にロールバック可能:

1. `git revert` で chezmoi リポジトリを 1Password 版に戻す
2. `chezmoi apply` で全マシンに適用
3. 1Password アプリ + CLI を再インストール
4. 1Password アカウントにログイン（データはクラウドに残っている）
5. chezmoi.toml の `[onepassword]` セクションを復元

---

#### 参考資料

- [Bitwarden SSH Agent](https://bitwarden.com/help/ssh-agent/)
- [Bitwarden SSH Agent ソケットパスの既知問題](https://github.com/bitwarden/clients/issues/13099)
- [Bitwarden Git Commit Signing](https://community.bitwarden.com/t/git-commit-signing-with-ssh-key/46495)
- [chezmoi age 暗号化](https://www.chezmoi.io/user-guide/encryption/age/)
- [chezmoi 暗号化 FAQ](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/)

# SSH 設定管理の chezmoi 化 - レビュー用サマリー

## 📋 変更の概要

SSH 設定と Git コミット署名を 1Password SSH Agent と chezmoi で管理する仕組みを実装しました。
複数のマシン（個人Mac、会社Mac、Ubuntu等）で安全かつ再現可能に SSH 環境を構築できるようになります。

## 🎯 目的

- **問題**: SSH 鍵をマシン間で共有すると紛失リスクが高い、手動管理は煩雑
- **解決**: 各マシン固有の SSH 鍵を 1Password で一元管理し、設定は chezmoi で自動配布

## 🔧 実装内容

### 1. 新規追加ファイル

#### `private_dot_ssh/config.tmpl`
SSH 設定のテンプレート。マシンタイプに応じて動的に生成されます。

**主な機能:**
- 1Password SSH Agent の統合（すべてのマシン共通）
- マシンタイプによる条件分岐:
  - 個人Mac: OrbStack、個人サーバー（debian/unraid）設定を含む
  - 会社Mac: GitHub を personal/work で分離
- ControlMaster によるパフォーマンス最適化

**テンプレート例:**
```ssh-config
{{- if .is_personal_mac }}
Host github.com
    HostName github.com
    User git
{{- end }}

{{- if .is_work_mac }}
Host github.com-personal
    HostName github.com
    User git
Host github.com-work
    HostName github.com
    User git
{{- end }}
```

#### `private_dot_ssh/allowed_signers.tmpl`
Git コミット署名の検証用ファイル。

**特徴:**
- `chezmoi.toml` の `ssh_public_keys` 配列から自動生成
- 複数マシンの公開鍵を一元管理
- 各マシンでのセットアップ手順をコメントで記載

#### `run_once_before_create-ssh-sockets.sh.tmpl`
ControlMaster 用の sockets ディレクトリを自動作成するスクリプト。

#### `private_dot_ssh/sockets/.keep`
sockets ディレクトリを Git で追跡するためのファイル。

#### `docs/en/ssh-setup.md`
詳細なセットアップガイド（240行）。

**内容:**
- 初回セットアップ手順（ステップ1-9）
- 複数マシン追加の手順
- マシンタイプ別の設定説明
- トラブルシューティング
- セキュリティノート

### 2. 更新ファイル

#### `dot_gitconfig.tmpl`
Git コミット署名の設定を追加。

**追加内容:**
```gitconfig
[gpg]
    format = ssh
[gpg "ssh"]
    program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
    allowedSignersFile = ~/.ssh/allowed_signers
[commit]
    gpgsign = true
[user]
    signingkey = {{ .ssh_signing_key }}
```

### 3. 設定ファイル

#### `~/.config/chezmoi/chezmoi.toml`
新しいデータフィールドを追加：

```toml
[data]
    # 既存の設定
    is_personal_mac = true
    is_work_mac = false
    git_name = "new-marty"
    git_email = "yumabuchi1998@gmail.com"
    
    # 新規追加
    ssh_public_keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... macbook",
    ]
    ssh_signing_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..."
```

## 🔐 セキュリティ設計

### SSH 鍵の管理方針

1. **マシンごとに別鍵**: `id_ed25519_macbook`, `id_ed25519_work` など
2. **秘密鍵は 1Password のみ**: ローカルディスクには保存しない（生成後削除推奨）
3. **1Password SSH Agent**: すべての鍵使用時に承認プロンプト表示
4. **Ed25519 形式**: 最新で最も安全な鍵タイプ

### Git コミット署名

- すべてのコミットが自動的に SSH 鍵で署名される
- `allowed_signers` で署名の検証が可能
- GitHub に署名用公開鍵を登録することで "Verified" バッジが表示される

## 🚀 動作確認

### このマシン（個人Mac）での検証

```bash
# SSH 接続テスト
$ ssh -T git@github.com
Hi new-marty! You've successfully authenticated...

# コミット署名テスト  
$ git log --show-signature -1
Good "git" signature for yumabuchi1998@gmail.com with ED25519 key SHA256:zkm...

# Push 成功
$ git push
To github.com:new-marty/chezmoi.git
   e003a9b..c87eeaa  main -> main
```

### 会社Mac でのシミュレーション

```bash
# テンプレートのドライラン
$ chezmoi execute-template --config /tmp/work_mac_config.toml < private_dot_ssh/config.tmpl
# → github.com-personal と github.com-work が生成されることを確認
# → OrbStack や個人サーバー設定が含まれないことを確認
```

## 📝 使用方法

### 新しいマシンでのセットアップ

1. `chezmoi init` で初期化
2. `~/.config/chezmoi/chezmoi.toml` でマシンタイプを設定
3. `chezmoi apply` で設定ファイルを生成
4. SSH 鍵を生成し、1Password と GitHub に登録
5. `chezmoi.toml` に公開鍵情報を追加して再適用

詳細は `docs/en/ssh-setup.md` を参照。

## 🔍 レビューポイント

### 確認していただきたい点

1. **テンプレートロジック**: マシンタイプの分岐は適切か？
2. **セキュリティ**: 秘密鍵の扱いに問題はないか？
3. **ドキュメント**: 初見でセットアップできる内容か？
4. **拡張性**: 新しいマシンタイプ追加は容易か？

### 既知の制限事項

1. **1Password CLI**: SSH Key タイプのアイテムは CLI で作成不可（GUI 必須）
2. **ソケットパス**: macOS の 1Password 専用（Linux/Windows は別パス）
3. **自動化の限界**: 公開鍵の追加は手動作業が必要

## 📊 影響範囲

### 変更されるファイル

**新規生成:**
- `~/.ssh/config`
- `~/.ssh/sockets/` (ディレクトリ)
- `~/.ssh/allowed_signers`
- `~/.gitconfig` (コミット署名設定が追加)

**既存ファイルへの影響:**
- `~/.ssh/config`: 既存設定（OrbStack等）は保持されるが、テンプレート化により上書き
- `~/.gitconfig`: SSH 署名設定が追記される

### 後方互換性

- 既存の SSH 鍵（`id_rsa`）は影響を受けない
- 既存サーバー設定（debian, unraid）は個人Mac でのみ保持

## 🎯 次のステップ

このPR マージ後：

1. 会社Mac でも同様にセットアップ
2. Ubuntu/Windows マシンへの展開
3. 必要に応じて他のチームメンバーへの展開

## 📚 参考リンク

- [1Password SSH Agent Documentation](https://developer.1password.com/docs/ssh/)
- [chezmoi Documentation](https://www.chezmoi.io/)
- [GitHub SSH Key Management](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

---

## コミット履歴

```
c87eeaa docs: Add comprehensive SSH setup guide for multi-machine configuration
94cf61f feat: Make SSH configuration portable across machines
e003a9b Update .gitconfig
01481a2 fix: Correct 1Password SSH Agent socket path
8609e06 docs: Add SSH configuration documentation
92c1991 Add SSH configuration management with 1Password integration
```

## 変更の差分サマリー

- **追加**: 5 ファイル（テンプレート 4 + ドキュメント 1）
- **更新**: 1 ファイル（`dot_gitconfig.tmpl`）
- **削除**: 0 ファイル
- **総行数**: 約 400 行追加

---

以上、レビューよろしくお願いします！🙏
質問や懸念点があればお気軽にコメントください。

# Gitツール

Git関連のエイリアス、ツール、設定。

## シェルエイリアス

| エイリアス | コマンド |
| ---------- | -------- |
| `gs`  | `git status` |
| `gl`  | `git log --graph --pretty=format:...` |
| `gls` | `git log --stat --summary` |
| `ga`  | `git add` |
| `br`  | `git branch --sort=-committerdate ...` |
| `gd`  | `git diff` |
| `gcm` | `git commit -m` |
| `gca` | `git commit --amend` |
| `gp`  | `git push origin head` |
| `sw`  | `git switch` |

---

## Git Configエイリアス

自分用の git 設定は `~/.gitconfig` に書く。git はこれを共有の設定の後に読むので、同じ項目は `~/.gitconfig` の値が優先される。次のエイリアスは共有の git 設定 `~/.config/git/config` で定義している:

```bash
git st          # 短いステータス
git lg          # カラー付きグラフログ
git lga         # 全ブランチのグラフログ
git amend       # メッセージ編集なしでamend
git undo        # 最後のコミットをソフトリセット
git wip         # クイックWIPコミット
git please      # leaseオプション付きforce push（安全）
git cleanup     # マージ済みブランチを削除
git aliases     # 全エイリアスを表示
```

---

## lazygit（エイリアス: `lg`）

ビジュアルなgit TUI。複雑な操作がコマンドラインより簡単。

```bash
lg              # lazygitを開く
```

### キー操作

| キー | アクション |
|------|----------|
| `Space` | ステージ/アンステージ |
| `a` | 全ファイルをステージ |
| `c` | コミット |
| `p` | プッシュ |
| `P` | プル |
| `b` | ブランチ操作 |
| `m` | マージ |
| `r` | リベース |
| `s` | スタッシュ |
| `?` | 全キーバインドを表示 |
| `q` | 終了 |

### ワークフロー例

1. 開く: `lg`
2. 全てステージ: `a`
3. コミット: `c` → メッセージ入力 → Enter
4. プッシュ: `p`

---

## delta

シンタックスハイライト付きgit diff強化ツール。

chezmoi が git のページャに delta を設定するのは、`chezmoi apply` の時点で delta がインストールされているときだけ。delta を後から入れたら、もう一度 `chezmoi apply` を実行する。設定されると次のコマンドで使われる:
- `git diff`
- `git log`
- `git show`

**機能:**
- シンタックスハイライト
- サイドバイサイド表示
- 行番号
- `n`/`N`でナビゲート

```bash
git diff              # deltaが自動的に使用される
git --no-pager diff   # deltaを一時的に無効化
```

---

## 比較: lazygit vs Git CLI

| タスク | Git CLI | Lazygit |
|--------|---------|---------|
| ファイルをステージ | `git add file` | ナビゲート + Space |
| 全てステージ | `git add .` | `a` |
| コミット | `git commit -m "msg"` | `c` + 入力 |
| プッシュ | `git push` | `p` |
| プル | `git pull` | `P` |
| ブランチ切替 | `git switch branch` | `b` + 選択 |
| インタラクティブリベース | `git rebase -i HEAD~n` | コミット上で `r` |
| コンフリクト解決 | 手動編集 | ビジュアルインターフェース |
| diffを見る | `git diff` | ファイルを選択 |
| スタッシュ | `git stash` | `s` |

---

## GitHub CLI (gh)

```bash
gh repo clone owner/repo    # クローン
gh repo create my-project   # 新しいリポジトリを作成
gh issue list               # Issue一覧
gh issue create             # Issueを作成
gh pr list                  # PR一覧
gh pr create                # PRを作成
gh pr checkout 123          # PRをチェックアウト
gh pr view --web            # ブラウザで開く
gh pr checks                # CIステータスを確認
gh gist create file.txt     # gistを作成
```

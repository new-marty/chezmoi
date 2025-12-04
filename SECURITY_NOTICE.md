# ⚠️ セキュリティ警告

## 問題

`dot_secrets.tmpl`に実際のAPIキーが含まれており、Gitリポジトリにコミットされていました。

## 対応済み

- ✅ `dot_secrets.tmpl`から機密情報を削除し、テンプレートに置き換えました
- ✅ 最新のコミットでは機密情報は含まれていません

## 重要な対応が必要

### 1. APIキーの無効化（緊急）

**すぐに以下のAPIキーを無効化してください：**

```
sk-REDACTED
```

- OpenAIのダッシュボードでこのAPIキーを無効化
- 新しいAPIキーを生成

### 2. Git履歴からの削除（推奨）

Git履歴にはまだ機密情報が残っています。完全に削除するには：

#### オプションA: BFG Repo-Cleanerを使用（推奨）

```bash
# BFGをインストール
brew install bfg

# 機密情報を含むファイルを履歴から削除
cd ~/.local/share/chezmoi
bfg --delete-files dot_secrets.tmpl
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push（注意：他の人が使っている場合は危険）
git push --force origin main
```

#### オプションB: git filter-branchを使用

```bash
cd ~/.local/share/chezmoi
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch dot_secrets.tmpl" \
  --prune-empty --tag-name-filter cat -- --all

# Force push
git push --force origin main
```

#### オプションC: リポジトリを再作成（最も安全）

```bash
# 新しいリポジトリを作成
# 現在のリポジトリを削除
# 機密情報を含まない状態で再初期化
```

### 3. 今後の対策

1. **chezmoiの暗号化機能を使用**
   ```bash
   chezmoi encrypt dot_secrets.tmpl
   ```

2. **1Password連携を使用**
   - `op inject`を使用してシークレットを注入

3. **環境変数を使用**
   - 実際のシークレットは環境変数から読み込む
   - テンプレートにはプレースホルダーのみ

4. **`.gitignore`の確認**
   - 機密情報を含むファイルが確実に無視されるように設定

## 参考

- [chezmoi encryption documentation](https://www.chezmoi.io/user-guide/encryption/)
- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)


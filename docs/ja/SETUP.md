# セットアップガイド

## 前提条件

- macOS (Apple Silicon または Intel)
- [Homebrew](https://brew.sh/)
- Git
- 1Password アカウント（シークレット管理用）

## 初期セットアップ

### 1. chezmoi をインストール

```bash
brew install chezmoi
```

### 2. dotfiles を初期化

```bash
chezmoi init --apply git@github.com:new-marty/chezmoi.git
```

### 3. マシンタイプを設定

`~/.config/chezmoi/chezmoi.toml` を作成または編集：

```toml
[data]
    is_personal_mac = true   # 個人 Mac の場合は true
    is_work_mac = false      # 会社 Mac の場合は true
    is_windows = false
    is_linux = false

[onepassword]
    command = "op"
```

### 4. 1Password CLI をセットアップ

```bash
# 1Password CLI をインストール
brew install --cask 1password-cli

# サインイン
op signin

# 接続確認
op vault list
```

### 5. 1Password にシークレットを作成

Personal vault に "Dotfiles Secrets" アイテムを作成：

```bash
op item create \
  --category "Secure Note" \
  --title "Dotfiles Secrets" \
  --vault "Personal" \
  'OPENAI_API_KEY[password]=your-api-key-here'
```

### 6. 設定を適用

```bash
chezmoi apply
```

### 7. Homebrew パッケージをインストール

```bash
brew bundle install --file=~/Brewfile
```

### 8. シェルを再起動

```bash
exec $SHELL -l
```

## マシン別セットアップ

### 個人 Mac

デフォルト設定。`Brewfile.common` と `Brewfile.personal_mac` のすべてのパッケージがインストールされます。

### 会社 Mac

`~/.config/chezmoi/chezmoi.toml` を編集：

```toml
[data]
    is_personal_mac = false
    is_work_mac = true
```

その後、Brewfile を再生成：

```bash
chezmoi apply
brew bundle install --file=~/Brewfile
```

## アップデート

### 最新の変更を取得

```bash
chezmoi update
```

### 変更を適用

```bash
chezmoi apply
```

### Homebrew パッケージをアップデート

```bash
brew bundle install --file=~/Brewfile
```

## トラブルシューティング

### chezmoi apply が失敗する

```bash
# エラーを確認
chezmoi apply --dry-run --verbose

# 差分を確認
chezmoi diff
```

### 1Password が動作しない

```bash
# 再認証
op signin

# 接続確認
op vault list

# テンプレートをテスト
chezmoi execute-template '{{ (onepasswordItemFields "Dotfiles Secrets" "Personal").OPENAI_API_KEY.value }}'
```

### シェルが正しく読み込まれない

```bash
# シェルを再起動
exec $SHELL -l

# sheldon キャッシュを再構築
rm ~/.cache/sheldon.zsh
sheldon source
```

### Brewfile の競合

```bash
# Brewfile を再生成
chezmoi apply --force

# または手動で同期
brew bundle dump --force --file=$(chezmoi source-path)/Brewfile
```


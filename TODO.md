# chezmoi 移行 TODO

## ✅ 完了済み

### 基本移行
- [x] chezmoi のインストールと初期化
- [x] dotfiles ファイルの chezmoi への追加
- [x] 設定ディレクトリの chezmoi への追加
- [x] Brewfile の追加
- [x] Git リポジトリへのコミット・プッシュ

### パス参照の修正
- [x] `dot_zsh/commands.zsh` - brew 関数を chezmoi source-path に対応
- [x] `dot_zshenv.tmpl` - 不要な BAT_CONFIG_PATH を削除
- [x] `dot_zsh/alias.zsh` - help 関数の参照を修正
- [x] `dot_zsh/suggestions.zsh` - dotfiles 参照を chezmoi cd に変更
- [x] `private_dot_config/sheldon/plugins.toml` - パスを ~/.zsh に修正
- [x] `private_dot_config/navi/cheats/cheats.cheat` - パス参照を修正

### シークレット管理
- [x] 1Password CLI のセットアップ
- [x] 1Password に "Dotfiles Secrets" アイテムを作成
- [x] `dot_secrets.tmpl` を 1Password 連携に変更
- [x] `~/.config/chezmoi/chezmoi.toml` を作成

### クリーンアップ
- [x] 旧 `~/dotfiles` ディレクトリを削除
- [x] `~/Brewfile` を削除（chezmoi で管理）
- [x] `~/.claude.json.corrupted.*` を削除
- [x] `~/.amazon-q.dotfiles.bak` を削除

### ドキュメント
- [x] README.md を作成

---

## 🔲 オプション（将来対応）

### マルチマシン対応
- [ ] Brewfile のテンプレート化（マシンごとのパッケージ分離）
- [ ] Windows 用パッケージ管理（winget）
- [ ] Linux 用パッケージ管理（apt）
- [ ] 設定ファイルの OS 分岐テンプレート化

### 追加改善
- [ ] chezmoi エイリアス追加 (`cm`, `cma`, `cmcd` など)
- [ ] chezmoi 自動コミット設定
- [ ] 他のシークレット（API キーなど）の 1Password 移行

---

## 📋 新規マシンでのセットアップ手順

```bash
# 1. chezmoi インストール
brew install chezmoi

# 2. dotfiles 取得・適用
chezmoi init --apply git@github.com:new-marty/chezmoi.git

# 3. 1Password CLI インストール・サインイン
brew install --cask 1password-cli
op signin

# 4. Homebrew パッケージインストール
brew bundle install --file=$(chezmoi source-path)/Brewfile

# 5. シェル再起動
exec $SHELL -l
```

## 🖥 マシン別 chezmoi.toml 設定

### 個人 Mac（この Mac）
```toml
[data]
    is_personal_mac = true
    is_work_mac = false
    is_windows = false
    is_linux = false
```

### 会社 Mac
```toml
[data]
    is_personal_mac = false
    is_work_mac = true
    is_windows = false
    is_linux = false
```

### Windows
```toml
[data]
    is_personal_mac = false
    is_work_mac = false
    is_windows = true
    is_linux = false
```

### Linux (Ubuntu)
```toml
[data]
    is_personal_mac = false
    is_work_mac = false
    is_windows = false
    is_linux = true
```

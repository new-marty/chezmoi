# TODO

## 完了済み

### 基本移行
- [x] chezmoi のインストールと初期化
- [x] dotfiles を chezmoi に追加
- [x] 設定ディレクトリを chezmoi に追加
- [x] Brewfile を追加
- [x] Git リポジトリにコミット・プッシュ

### パス参照の修正
- [x] `dot_zsh/commands.zsh` - brew 関数を chezmoi source-path に対応
- [x] `dot_zshenv.tmpl` - 未使用の BAT_CONFIG_PATH を削除
- [x] `dot_zsh/alias.zsh` - help 関数の参照を修正
- [x] `dot_zsh/suggestions.zsh` - dotfiles 参照を chezmoi cd に変更
- [x] `private_dot_config/sheldon/plugins.toml` - パスを ~/.zsh に修正
- [x] `private_dot_config/navi/cheats/cheats.cheat` - パス参照を修正

### シークレット管理
- [x] 1Password CLI のセットアップ
- [x] 1Password に "Dotfiles Secrets" アイテムを作成
- [x] `dot_secrets.tmpl` を 1Password 連携に更新
- [x] `~/.config/chezmoi/chezmoi.toml` を作成

### Brewfile
- [x] Brewfile を common/personal_mac/work_mac に分離してテンプレート化
- [x] brew ラッパーにインタラクティブなパッケージ選択機能を追加

### ドキュメント
- [x] 英語の README.md を作成
- [x] docs/ フォルダ構造を作成
- [x] 日本語訳を追加

### クリーンアップ
- [x] 旧 `~/dotfiles` ディレクトリを削除
- [x] `~/Brewfile` を削除（chezmoi で管理）
- [x] `~/.claude.json.corrupted.*` ファイルを削除
- [x] `~/.amazon-q.dotfiles.bak` を削除
- [x] `.gitattributes` を削除

---

## オプション（将来）

### マルチマシン対応
- [ ] Windows 用 Brewfile テンプレート（winget）
- [ ] Linux 用 Brewfile テンプレート（apt）
- [ ] OS 固有の設定テンプレート
- [ ] サーバー Linux 対応
- [ ] デスクトップ Linux 対応

### 改善
- [ ] chezmoi エイリアスを追加（`cm`, `cma`, `cmcd`）
- [ ] chezmoi の自動コミット設定
- [ ] 他のシークレットを 1Password に移行

---

## 新規マシンセットアップチェックリスト

```bash
# 1. chezmoi をインストール
brew install chezmoi

# 2. dotfiles を初期化
chezmoi init --apply git@github.com:new-marty/chezmoi.git

# 3. 1Password CLI をインストールしてサインイン
brew install --cask 1password-cli
op signin

# 4. Homebrew パッケージをインストール
brew bundle install --file=$(chezmoi source-path)/Brewfile

# 5. シェルを再起動
exec $SHELL -l
```

## マシン別 chezmoi.toml

### 個人 Mac
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

### Linux
```toml
[data]
    is_personal_mac = false
    is_work_mac = false
    is_windows = false
    is_linux = true
```


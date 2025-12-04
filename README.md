# Dotfiles (chezmoi)

個人の開発環境設定ファイル。[chezmoi](https://www.chezmoi.io/) で管理。

## 🚀 クイックスタート

### 新規マシンでのセットアップ

```bash
# 1. chezmoi をインストール
brew install chezmoi

# 2. dotfiles を取得して適用
chezmoi init --apply git@github.com:new-marty/chezmoi.git

# 3. 1Password CLI をインストール（secrets 用）
brew install --cask 1password-cli

# 4. 1Password にサインイン
op signin

# 5. Homebrew パッケージをインストール
brew bundle install --file=$(chezmoi source-path)/Brewfile
```

### 既存マシンでの更新

```bash
chezmoi update
```

## 📁 構成

```
~/.local/share/chezmoi/
├── Brewfile                    # Homebrew パッケージ
├── dot_secrets.tmpl            # シークレット（1Password 連携）
├── dot_zprofile                # zsh profile
├── dot_zshenv.tmpl             # 環境変数
├── dot_zshrc                   # zsh 設定
├── dot_zsh/                    # zsh カスタム設定
│   ├── alias.zsh               # エイリアス
│   ├── commands.zsh            # カスタムコマンド
│   ├── peco.zsh                # peco 設定
│   ├── steeef.zsh-theme        # プロンプトテーマ
│   └── suggestions.zsh         # コマンド候補
├── dot_vscode/                 # VSCode カスタム CSS/JS
├── private_dot_config/
│   ├── ghostty/                # Ghostty ターミナル設定
│   ├── navi/                   # navi チートシート
│   ├── raycast/                # Raycast スクリプト
│   └── sheldon/                # Sheldon プラグイン管理
└── private_dot_Library/        # macOS 固有設定
    └── Application Support/Code/User/settings.json
```

## 🔐 シークレット管理

シークレットは [1Password CLI](https://developer.1password.com/docs/cli/) で管理。

```bash
# シークレットの確認
op item get "Dotfiles Secrets" --vault Personal

# シークレットの更新
op item edit "Dotfiles Secrets" --vault Personal 'OPENAI_API_KEY=new-value'
```

chezmoi は `dot_secrets.tmpl` テンプレートを通じて 1Password から値を取得。

## ⚙️ 設定

### chezmoi 設定 (`~/.config/chezmoi/chezmoi.toml`)

```toml
[data]
    is_personal_mac = true   # 個人 Mac
    is_work_mac = false      # 会社 Mac
    is_windows = false       # Windows
    is_linux = false         # Linux

[onepassword]
    command = "op"
```

### マルチマシン対応

各マシンで `chezmoi.toml` の `[data]` セクションを設定：

| マシン | is_personal_mac | is_work_mac | is_windows | is_linux |
|--------|-----------------|-------------|------------|----------|
| 個人 Mac | true | false | false | false |
| 会社 Mac | false | true | false | false |
| Windows | false | false | true | false |
| Linux | false | false | false | true |

## 🛠 カスタムコマンド

| コマンド | 説明 |
|----------|------|
| `help` | カスタムコマンドとキーバインドのヘルプを表示 |
| `fcat` | ファイル内容を再帰的に表示 |
| `ts2mp4` | TS ファイルを MP4 に変換 |
| `mkcd` | ディレクトリ作成 & 移動 |
| `cdf` | fuzzy finder でディレクトリ移動 |

## ⌨️ キーバインド

| キー | 機能 |
|------|------|
| `Ctrl+G` | コマンドテンプレート |
| `Ctrl+S` | スマート候補（プロジェクト種別に応じた提案） |
| `Ctrl+F` | よく使うコマンド |
| `Ctrl+N` | navi チートシート |
| `Ctrl+R` | peco 履歴検索 |
| `Ctrl+H` | atuin 履歴検索 |

## 📝 よく使う chezmoi コマンド

```bash
# 差分を確認
chezmoi diff

# 変更を適用
chezmoi apply

# ソースディレクトリを開く
chezmoi cd

# 管理ファイル一覧
chezmoi managed

# テンプレートをテスト
chezmoi execute-template '{{ .chezmoi.os }}'

# 編集して自動追加
chezmoi edit ~/.zshrc
```

## 🔧 トラブルシューティング

### 1Password 連携が動かない

```bash
# 1Password にサインイン
op signin

# 接続確認
op vault list
```

### chezmoi apply でエラー

```bash
# dry-run で確認
chezmoi apply --dry-run --verbose

# 差分を確認
chezmoi diff
```

### シェルが正しく読み込まれない

```bash
# シェルを再起動
exec $SHELL -l

# sheldon を再ビルド
rm ~/.cache/sheldon.zsh
sheldon source
```

## 📚 参考

- [chezmoi 公式ドキュメント](https://www.chezmoi.io/)
- [1Password CLI](https://developer.1password.com/docs/cli/)


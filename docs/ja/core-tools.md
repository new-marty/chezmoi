# コアツール

このdotfiles設定の基盤となるツール群。

## chezmoi

マルチマシン構成とテンプレートに対応したdotfileマネージャー。

```bash
chezmoi apply              # ソースからホームに変更を適用
chezmoi diff               # 変更内容を表示
chezmoi edit ~/.zshrc      # 管理対象ファイルを編集
chezmoi update             # リモートから更新
chezmoi cd                 # ソースディレクトリに移動
chezmoi add ~/.config      # 新しいファイルを管理対象に追加
chezmoi managed            # 管理対象ファイル一覧
chezmoi re-add ~/.zshrc    # 外部変更後に再追加
chezmoi execute-template '{{ .chezmoi.hostname }}'  # テンプレートテスト
```

**エイリアス:**

| エイリアス | コマンド          |
| ---------- | ---------------- |
| `cm`       | `chezmoi`        |
| `cma`      | `chezmoi apply`  |
| `cmd`      | `chezmoi diff`   |
| `cme`      | `chezmoi edit`   |
| `cmu`      | `chezmoi update` |
| `cmcd`     | `chezmoi cd`     |

---

## sheldon

高速で設定可能なzshプラグインマネージャー。

```bash
sheldon source              # プラグインをリロード
sheldon list                # インストール済みプラグイン一覧
sheldon add name --github user/repo  # プラグインを追加
sheldon remove name         # プラグインを削除
sheldon lock --update       # 全プラグインを更新
```

**設定ファイル:** `~/.config/sheldon/plugins.toml`

---

## atuin

同期、検索、統計機能を備えた魔法のようなシェル履歴。

```bash
atuin search                # 履歴を検索
atuin search -i             # インタラクティブ検索
atuin stats                 # 統計を表示
atuin import zsh            # zshから履歴をインポート
atuin sync                  # 履歴を同期（設定時）
atuin search --cwd .        # 現在のディレクトリの履歴
```

**キーバインド:** `Ctrl+H` でインタラクティブ検索

---

## zoxide

使用パターンを学習するスマートなcdコマンド。

```bash
z projects        # "projects"に最もマッチするディレクトリにジャンプ
z local share     # 複数キーワードでジャンプ
zi                # fzfでインタラクティブ選択
zoxide add ~/path # ディレクトリを手動追加
zoxide remove ~/path  # ディレクトリを削除
zoxide query -l   # スコア付きエントリ一覧
```

**ヒント:**
- 短いキーワードを使う: `z Downloads` の代わりに `z dow`
- よく使うディレクトリほどスコアが高くなる

---

## navi

コマンドラインのインタラクティブチートシート。

```bash
navi                  # インタラクティブチートシートを開く
navi --query git      # 特定のトピックを検索
```

**キーバインド:** `Ctrl+N` でnaviウィジェットを開く

**カスタムチート:** `~/.config/navi/cheats/cheats.cheat`

---

## fzf

コマンドラインのファジーファインダー。

```bash
fzf                              # 基本的なあいまい検索
code $(fzf)                      # ファイルを見つけてエディタで開く
fzf --preview 'bat --color=always {}'  # プレビュー付き
fzf -m                           # 複数選択（Tab）
find ~/Documents -type f | fzf   # 特定のディレクトリで検索
```

**統合済み:** Tab補完、Ctrl+Gテンプレート、Ctrl+Sサジェスト

---

## peco

インタラクティブフィルターツール（履歴に使用）。

```bash
cat file.txt | peco    # 入力をフィルタ
history | peco         # 履歴検索
```

**キーバインド:**
- `Ctrl+R` - コマンド履歴を検索
- `Ctrl+U` - 最近のディレクトリにジャンプ

---

## thefuck

直前のコンソールコマンドを修正する。

```bash
$ gut status
git: 'gut' is not a git command.

$ fuck
git status [enter/↑/↓/ctrl+c]
```

---

## eza

アイコンとgit統合を備えたモダンなls代替。

```bash
ls              # 基本リスト（eza があればエイリアス）
ll              # 長形式で全ファイル
lll             # gitステータス付き
eza --tree --level=2  # ツリー表示
eza -l --sort=modified  # 更新時刻でソート
```

---

## bat

シンタックスハイライト付きのcat代替。

```bash
bat file.py                    # シンタックスハイライト付きで表示
bat -n file.py                 # 行番号を表示
bat --line-range 10:20 file.py # 特定の行を表示
bat -p file.py                 # プレーン出力
```

---

## ripgrep (rg)

.gitignoreを尊重する高速grep代替。

```bash
rg "pattern"              # パターンを検索
rg "pattern" -t js        # 特定のファイルタイプで検索
rg -i "pattern"           # 大文字小文字を区別しない
rg -l "pattern"           # ファイル名のみ表示
rg --hidden "pattern"     # 隠しファイルも検索
rg -C 3 "pattern"         # コンテキスト行を表示
rg "old" --replace "new"  # 置換（プレビュー）
```

---

## fd

高速でユーザーフレンドリーなfind代替。

```bash
fd readme           # 名前でファイルを検索
fd -e js            # 拡張子で検索
fd -t d             # ディレクトリのみ
fd -t f             # ファイルのみ
fd -H pattern       # 隠しファイルを含める
fd -e jpg -x convert {} {.}.png  # 結果にコマンドを実行
```

---

## gh

ターミナルからGitHubを操作するCLI。

```bash
gh repo clone owner/repo    # リポジトリをクローン
gh repo create my-project   # 新しいリポジトリを作成
gh issue list               # Issueを表示
gh pr list                  # PRを表示
gh pr create                # PRを作成
gh pr checkout 123          # PRをチェックアウト
gh pr view --web            # ブラウザで開く
```

---

## mise

統合ランタイムバージョンマネージャー（nvm、pyenv、rbenvなどの代替）。

```bash
mise install node@20        # Node.js 20をインストール
mise install python@3.12    # Python 3.12をインストール
mise use node@20            # 現在のディレクトリでNode.js 20を使用
mise use --global node@20   # グローバルのデフォルトを設定
mise ls                     # インストール済みバージョン一覧
mise ls-remote node         # 利用可能なバージョン一覧
mise current                # 現在のバージョンを表示
mise prune                  # 未使用のバージョンを削除
```

**設定ファイル:** `~/.config/mise/config.toml` またはプロジェクト毎の `.mise.toml`

**対応ツール:** node、python、ruby、go、rust、javaなど多数

---

## update-dev

すべての開発ツールを一括更新。

```bash
update-dev                  # すべてを更新
update-dev --dry-run        # 更新内容をプレビュー
```

**更新対象:**
- Homebrew（brew update && brew upgrade）
- Chezmoi（chezmoi update）
- Sheldonプラグイン（sheldon lock --update）
- Atuin（atuin sync）
- Miseランタイム（mise upgrade）


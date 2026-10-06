# 導入と設定の詳細

導入の手順に加えて、オプトインのスイッチごとに書かれるファイル、マシン固有のファイルの読み込まれ方、エディタの決まり方、以前の構成からの移行を扱う。

## 導入の手順

1. chezmoi を入れ、このリポジトリを chezmoi のソースディレクトリに clone する。自分の変更を git で残したいなら、先にフォークして、ここではフォークの名前を使う。

   ```bash
   brew install chezmoi
   chezmoi init new-marty/chezmoi
   ```

2. ホームディレクトリで何が変わるかを確かめる。

   ```bash
   chezmoi diff
   ```

3. 置き換わるファイルから、残したいものを移しておく。置き換わるのは `~/.zshrc`、`~/.zshenv`、`~/.zprofile`、`~/.ssh/config`、`~/.editorconfig`、`~/.gitignore_global` で、`~/.zsh/` と `~/.config/git/config` が新しく入る。自分のエイリアスと関数は `~/.zshrc.local` に、`PATH` と環境変数は `~/.zshenv.local` に、SSH のホストは `~/.ssh/config.local` に写す。共有のファイルがこれらを読み込む（[マシン固有のファイル](#マシン固有のファイル)を参照）。既存の `~/.gitconfig` はそのまま残る。

4. 適用する。chezmoi は既存のファイルごとに確認してくる。diff で差分を見てから、上書きするか飛ばすかを選ぶ。

   ```bash
   chezmoi apply --less-interactive
   ```

5. 新しいターミナルを開く。

最初から `chezmoi init --apply` を使ったり、初回に素の `chezmoi apply` を実行したりしてはいけない。どちらも既存の `~/.zshrc` や `~/.ssh/config` などを確認なしで上書きする（[chezmoi issue #1551](https://github.com/twpayne/chezmoi/issues/1551)）。`--less-interactive` には chezmoi v2.66.0 以降が必要だ（`chezmoi --version` で確認できる）。`chezmoi init` は何も質問せず、設定ファイルもなくてよい。

設定を変えるときは、ホームディレクトリのファイルを直接書き換えず `chezmoi edit ~/.zshrc`（エイリアス `cme`）で編集し、`chezmoi apply`（`cma`）で反映する。このリポジトリの更新を取り込むのは `chezmoi update`（`cmu`）だ。

エイリアスを足したり、自分のマシンでだけ変えたりするときは `~/.zshrc.local` に書く。すべてのマシンで変えるなら、共有のファイルを `chezmoi edit ~/.zsh/alias.zsh` で編集して反映する。どちらも `sz` か新しいターミナルで読み込まれる。

## オプトインのスイッチ

コア部分（zsh、git、SSH、editorconfig）は常に適用される。下の表の設定は、`~/.config/chezmoi/chezmoi.toml` の `optin` にスイッチ名を書いたマシンでだけ適用される。このファイルは `chezmoi edit-config` で開ける。

```toml
[data]
    optin = ["vscode", "editor-extensions", "ghostty", "tmux"]
```

| スイッチ   | chezmoi が書くファイル（`~` 以下）                                  |
| ---------- | ------------------------------------------------------------------- |
| `vscode`   | `Library/Application Support/Code/User/` の `settings.json`、`keybindings.json` |
| `cursor`   | `Library/Application Support/Cursor/User/settings.json`             |
| `ghostty`  | `.config/ghostty/config`、`.config/ghostty/themes/poimandres.ghostty` |
| `tmux`     | `.config/tmux/tmux.conf`、`.config/tmux/cheatsheet.md`。加えて tmux プラグインマネージャー（tpm）を `~/.tmux/plugins/tpm` に一度だけ clone する |
| `navi`     | `.config/navi/cheats/cheats.cheat`                                  |
| `mise`     | `.config/mise/config.toml`                                          |
| `justfile` | `justfile`                                                          |
| `karabiner`| `.config/karabiner`(ソースディレクトリの `karabiner/` へのシンボリックリンク) |
| `omz`      | `.zsh/omz-custom/plugins/`。Oh My Zsh 用の zsh プラグインで、sheldon の代わりに Oh My Zsh がこれを読み込む（[下記](#sheldon-の代わりに-oh-my-zsh-を使うomz)） |
| `editor-extensions` | なし。VS Code と Cursor の設定が Poimandres と catppuccin の拡張、Hack Nerd Font を使う |
| `editor-builtin` | なし。VS Code と Cursor の設定が標準テーマを Poimandres の色に塗り替え、システムのフォントを使う。それらの拡張やフォントを入れないマシン向け |

VS Code と Cursor は、同じ形式の設定を別々の場所から読む。そこで両方の `settings.json` を 1 つのテンプレートから生成しており、どちらか一方でも両方でも選べる。見た目には既定がない。`vscode` か `cursor` を選んだら、`editor-extensions` と `editor-builtin` のどちらか一方も必ず選ぶ。選ばないと `chezmoi apply` はそう告げて止まる（`.chezmoidata/optin.toml` の `[optin_choices.editor-look]`）。スイッチと書くファイルの対応は `.chezmoidata/optin.toml` で決めており、この表はその写しだ。そこにない名前を書くと、`chezmoi apply` は有効な名前を挙げたエラーで止まる。

一覧を変えたら `chezmoi apply --less-interactive` で反映する。素の `chezmoi apply` は、自分で書いた `~/.config/ghostty/config` のような既存のファイルを確認なしで上書きする。

### スイッチを外すとき

スイッチを外しても何も削除されない。chezmoi はそのスイッチのファイルを管理しなくなるだけで、何も知らせず、ファイルはディスクに残って古くなっていく。スイッチができる前からこの dotfiles を使っていたマシンでも同じことが起きる。次に `chezmoi apply` を実行する前に `optin` を書いておかないと、残したかった設定が管理から外れる。

`just optin` は、スイッチごとに「このマシンで選ばれているか」「ファイルがあるか」「chezmoi がまだ管理しているか」を表示する。chezmoi が書いたファイルのうち、もう管理しておらず、その後だれも変更していないものには、削除用の `rm` コマンドも表示する。chezmoi が書いた後に変更されたファイルは、`rm` を出さずに確認用の一覧に載せる。実行には [just](https://just.systems/) が必要だ。`~/justfile` がない場合は `just --justfile "$(chezmoi source-path)/justfile" optin` で実行する。

**消すのはファイルだけにし、ディレクトリごと消してはいけない。** `~/Library/Application Support/Cursor` のようなディレクトリには、拡張機能やワークスペースの状態といったアプリ自身のデータも入っている。

### sheldon の代わりに Oh My Zsh を使う（`omz`）

`omz` を選ぶと、zsh のプラグインを sheldon ではなく、手で `~/.oh-my-zsh` に入れた Oh My Zsh で読み込む。読み込むのは `git` と、このリポジトリに同梱した 3 つ（`~/.zsh/omz-custom` に書かれる）。上下の矢印キーは入力中の文字列で履歴を検索する。エイリアス、コマンド、プロンプトは、どちらでも同じ `~/.zsh/*` のファイル。Oh My Zsh を入れる前でもシェルは起動する。sheldon のないマシンと同じく、プラグインなしで `~/.zsh/*` を読み込む。`just doctor` は、どの読み込み方になっているかを表示する。

Oh My Zsh は zip から一度だけ入れる。

```bash
curl -fsSL -o ~/Downloads/ohmyzsh.zip https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip
unzip -q ~/Downloads/ohmyzsh.zip -d ~/Downloads
mv ~/Downloads/ohmyzsh-master ~/.oh-my-zsh
```

Oh My Zsh の `install.sh` は実行しない。`~/.zshrc` を置き換えてしまうが、`~/.zshrc` は chezmoi が書くもので、`omz` を選べば Oh My Zsh を読み込む。chezmoi は `~/.oh-my-zsh` の中に何も書かないので、Oh My Zsh の更新はこのディレクトリを新しい zip で置き換えればよい。Oh My Zsh 自身の更新確認は git を使うので止めてある。

Oh My Zsh に入っていないプラグインは、apply で clone しなくて済むよう、リリースを固定して `dot_zsh/omz-custom` に置いている。

| プラグイン                     | バージョン |
| ------------------------------ | ---------- |
| zsh-autosuggestions            | v0.7.1     |
| zsh-syntax-highlighting        | 0.8.0      |
| zsh-history-substring-search   | v1.1.0     |

新しいリリースにするときは、`scripts/vendor-omz-plugins.sh` の固定を書き換え、clone できるマシンでスクリプトを実行して、結果をコミットする。

sheldon に戻すときは、sheldon を入れてから一覧の `omz` を外して apply する。chezmoi は `~/.zsh/omz-custom` を管理しなくなり、ファイルは残るので、これを消し、ほかで使っていなければ `~/.oh-my-zsh` も消す。

### ターミナルの配色

steeef のプロンプトはターミナルのパレット番号で色を指定するので、パレットが Poimandres なら Poimandres の色になる。Ghostty は `ghostty` スイッチが、VS Code と Cursor のターミナルは `editor-builtin` がパレットを設定する。iTerm2 などほかのターミナルは chezmoi では管理しないので、Poimandres のカラープリセットを手で読み込む（iTerm2 なら Settings → Profiles → Colors → Color Presets → Import）。色の値は `private_dot_config/ghostty/themes/poimandres.ghostty` にある。

## マシン固有のファイル

マシンごとに違うものは、共有ファイルが読み込むローカルファイルに書く。名前や鍵、公開したくないホストはここに書き、リポジトリには入れない。

| ファイル              | 読み込まれる場所                         | 書くもの                                  |
| --------------------- | ---------------------------------------- | ----------------------------------------- |
| `~/.zshenv.local`     | `~/.zshenv` の最後                       | 追加の `PATH`、環境変数                   |
| `~/.zshrc.local`      | `~/.zshrc` の最後                        | 自分用のエイリアスと関数                  |
| `~/.gitconfig`        | git が `~/.config/git/config` の後に読む | `user.name`、`user.email`、コミット署名   |
| `~/.ssh/config.local` | `~/.ssh/config` の先頭                   | ホスト、`IdentityFile`、`IdentityAgent`   |

3 つの `.local` ファイルは chezmoi の管理外で、存在するときだけ読み込まれ、どれも共有の設定より優先される。zsh の 2 つは最後に読み込むことで優先させている。一方、`~/.ssh/config.local` は先頭で読み込む。ssh は各オプションについて最初に見つけた値を使うからだ。詳しくは [SSH](ssh-setup.md) を参照。

### git の `~/.gitconfig` は自分のもの

共有の git 設定は `~/.config/git/config` にある。git はその後に `~/.gitconfig` を読むので、こちらの値が優先される。`git config --global` の書き込み先もこのファイルだ。chezmoi はこのファイルがなければコメントだけで作り、その後は変更しない。もともと持っていた `~/.gitconfig` はそのまま残り、その中の設定はすべて共有の設定より優先される。共有の設定に任せたい項目は消しておく。最小限の `~/.gitconfig` は次のとおり。

```ini
[user]
    name = Your Name
    email = you@example.com
```

### 以前の構成で設定したマシン

2026 年 10 月 5 日より前にこのリポジトリを適用したマシンだけが対象だ。以前の版は、git の設定をすべて `~/.gitconfig` に書いていた。chezmoi はこのファイルを置き換えない。git はこのファイルを最後に読むので、`~/.config/git/config` の設定（後述のエディタの選択も含む）が上書きされたままになる。名前、メールアドレス、署名、意図して残したい上書きだけを残して削る。`~/.gitconfig.local` を読む `[include]` があれば、そのファイルの中身を `~/.gitconfig` に移して `[include]` を消す。

### API キー

API キーはシェルの起動ファイルに書かない。そこで export した値は、シェルが起動するすべてのプロセスに渡ってしまう。キーは macOS のキーチェーンに保存する。

```bash
security add-generic-password -a "$USER" -s my-api-key -w
```

読み出すのは、プロジェクトの direnv 用 `.envrc` や `~/.zshrc.local` の関数の中など、必要な場所だけにする。

```bash
security find-generic-password -a "$USER" -s my-api-key -w
```

## エディタの決まり方

git の `core.editor` とシェルのエイリアス `c` は同じエディタを開く。どれを使うかはシェルの起動時ではなく、chezmoi がファイルを書くときに次の順で決まる。

1. `optin` に `cursor` があり、`cursor` コマンドもあれば Cursor（`cursor --wait`）。
2. そうでなく `code` コマンドがあれば VS Code（`code --wait`）。
3. どちらもなければ設定しない。`core.editor` は空のまま、`c` も定義されない。

git のページャの delta も同じで、chezmoi が git の設定を書くときに delta が入っていれば設定される。Cursor、VS Code、delta を後から入れたら、もう一度 `chezmoi apply` を実行する。

特定のマシンだけ別のエディタにしたいときは、`~/.gitconfig` で `core.editor` を設定し、`~/.zshenv.local` で `DOTFILES_GUI_EDITOR` を設定する（または `~/.zshrc.local` で `c` を定義し直す）。

## 新しいマシンを用意する

このリポジトリにはパッケージの一覧がない。元のマシンで `brew bundle dump --file=-` を実行し、その出力から必要なものを新しいマシンに入れる。そのあと README の導入手順に従う。

例外は VS Code の拡張機能で、`vscode/extensions.txt` に 1 行に 1 つずつ ID を並べてある。`just vscode-extensions` は、そのうち入っていないものを入れる。`just vscode-extensions-dump` は VS Code に今入っているものから一覧を書き直すので、`git diff` で確かめてからコミットする。`justfile` スイッチを選んでいないマシンでは `just --justfile "$(chezmoi source-path)/justfile" vscode-extensions` と打つ。

### `git clone` ができないマシン

`chezmoi init` が clone できないマシンでは、リポジトリの zip を chezmoi のソースの場所に置く。あとで更新するときも、このディレクトリを新しい zip で置き換える。`chezmoi update` は git を使うので動かない。`tmux` スイッチはプラグインマネージャーを clone するので選ばない。

```bash
curl -fsSL -o ~/Downloads/chezmoi-src.zip https://github.com/new-marty/chezmoi/archive/refs/heads/main.zip
unzip -q ~/Downloads/chezmoi-src.zip -d ~/Downloads
mkdir -p ~/.local/share
mv ~/Downloads/chezmoi-main ~/.local/share/chezmoi
```

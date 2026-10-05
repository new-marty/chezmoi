# マシン固有の設定とオプトイン

この dotfiles は、設定なしで誰のマシンにも同じように適用できるように作っている。リポジトリには名前、メールアドレス、鍵、ホストを一切入れていない。マシンごとに違う設定は、chezmoi の管理外にあるローカルファイルに書く。アプリケーションの設定は、使うマシンでだけ有効にする（オプトイン）。

## 導入

```bash
brew install chezmoi
chezmoi init new-marty/chezmoi
chezmoi diff                          # ホームディレクトリで何が変わるかを確認
chezmoi apply --less-interactive      # 既存のファイルを上書きする前に確認する
```

`--less-interactive` には chezmoi v2.66 以降が必要だ（`chezmoi --version` で確認できる）。最初から `chezmoi init --apply` を使ったり、初回に素の `chezmoi apply` を実行したりしてはいけない。どちらも既存の `~/.zshrc` や `~/.ssh/config` などを確認なしで上書きする（[chezmoi issue #1551](https://github.com/twpayne/chezmoi/issues/1551)）。

`chezmoi init` は何も質問せず、`chezmoi.toml` もなくてよい。

## オプトインするアプリケーション設定

設定なしで適用されるのはコア部分（zsh、git、SSH、editorconfig）だけだ。下の表の設定は、`~/.config/chezmoi/chezmoi.toml` にスイッチ名を書いたマシンでだけ適用される。

```toml
[data]
    optin = ["vscode", "ghostty", "tmux"]
```

| スイッチ   | chezmoi が書くファイル（`~` 以下）                                  | 設定する内容                              |
| ---------- | ------------------------------------------------------------------- | ----------------------------------------- |
| `vscode`   | `Library/Application Support/Code/User/` の `settings.json`、`keybindings.json`、`extensions.json` | VS Code の設定とキーバインド |
| `cursor`   | `Library/Application Support/Cursor/User/settings.json`             | Cursor の設定                             |
| `ghostty`  | `.config/ghostty/config`、`.config/ghostty/themes/poimandres.ghostty` | Ghostty の設定とテーマ                  |
| `tmux`     | `.config/tmux/tmux.conf`、`.config/tmux/cheatsheet.md`。加えて tmux プラグインマネージャー（tpm）を `~/.tmux/plugins/tpm` に一度だけ clone する | tmux |
| `navi`     | `.config/navi/cheats/cheats.cheat`                                  | navi のチートシート                       |
| `mise`     | `.config/mise/config.toml`                                          | mise のグローバルなツールバージョン       |
| `justfile` | `justfile`                                                          | 更新と診断のレシピを持つ `~/justfile`     |

VS Code と Cursor は、同じ形式の設定を別々の場所から読む。そこで両方の `settings.json` を 1 つの共有テンプレートから生成しており、どちらか一方でも両方でも選べる。表の正本は `.chezmoidata/optin.toml` にある。そこにない名前を書くと、`chezmoi apply` は有効な名前を挙げたエラーで止まる。

スイッチを外しても何も削除されない。chezmoi はそのスイッチのファイルを管理しなくなるだけで、何も知らせず、ファイルはそのままディスクに残って古くなっていく。スイッチができる前からこの dotfiles を使っていた場合も同じことが起きる。次に `chezmoi apply` を実行する前に `optin` を書いておかないと、残したかった設定が管理から外れる。

`just optin` は、スイッチごとに「このマシンで選ばれているか」「ファイルがあるか」「chezmoi がまだ管理しているか」を表示する。chezmoi が書いたファイルのうち、もう管理しておらず、その後だれも変更していないものについては、削除用の `rm` コマンドも表示する。chezmoi が書いた後にアプリや自分が変更したファイルは、`rm` を出さずに確認用の一覧として表示するので、中身を見てから消すかどうか決める。表示するのはファイルだけで、ディレクトリは対象にしない。`~/Library/Application Support/Cursor` のようなディレクトリには、拡張機能やワークスペースの状態といったアプリ自身のデータも入っている。オプトインをやめるときも、ディレクトリごと消してはいけない。

`~/justfile` がない場合は `just --justfile "$(chezmoi source-path)/justfile" optin` で実行する。

## マシン固有のファイル

マシンごとに違うものは、共有ファイルが読み込むローカルファイルに書く。名前や鍵、公開したくないホストはここに書く。リポジトリにはこれらのファイルの中身が入らない。3 つの `*.local` ファイルは chezmoi の管理外で、存在するときだけ読み込まれる。`~/.gitconfig` だけは扱いが違う。chezmoi はこのファイルがなければコメントだけで作るので、apply の後は必ず存在する。ただし、その後 chezmoi が変更することはない。

| ファイル              | 読み込む場所                        | 主な中身                                  |
| --------------------- | ----------------------------------- | ----------------------------------------- |
| `~/.zshenv.local`     | `.zshenv` の最後                    | 追加の `PATH`、環境変数による切り替え     |
| `~/.zshrc.local`      | `.zshrc` の最後                     | 自分用のエイリアスと関数                  |
| `~/.gitconfig`        | git が `~/.config/git/config` の後に読む | `user.name`、`user.email`、コミット署名 |
| `~/.ssh/config.local` | `.ssh/config` の先頭                | ホスト、`IdentityFile`、`IdentityAgent`   |

SSH のファイルだけは最後でなく先頭で読み込む。ssh は各オプションについて最初に見つけた値を使うので、こうすると `config.local` の設定が共有の既定値より優先される。詳しくは [SSH](ssh-setup.md) を参照。

共有の git 設定は `~/.config/git/config` にあり、`~/.gitconfig` はマシンごとのファイルになる。すでにある `~/.gitconfig` はそのまま残る。git は `~/.config/git/config` の後に `~/.gitconfig` を読むので、こちらの値が優先される。`git config --global` の書き込み先もこのファイルだ。最小限の `~/.gitconfig` は次のとおり。

```ini
[user]
    name = Your Name
    email = you@example.com
```

以前の構成でこのリポジトリを当てたマシンでは、`~/.gitconfig` が昔の共有設定をまるごと写したファイルになっている。chezmoi はこれを置き換えない。git はこのファイルを最後に読むので、`~/.config/git/config` の設定（エディタの選び方も含む）は上書きされたままになる。名前、メールアドレス、署名、意図して上書きしたい設定だけを残して削り、`~/.gitconfig.local` を読む `[include]` を消して、そのファイルの中身を `~/.gitconfig` に移す。

API キーはシェルの起動ファイルに書かない。そこで export した値は、シェルが起動するすべてのプロセスに渡ってしまう。キーは `security add-generic-password -a "$USER" -s my-api-key -w` で macOS のキーチェーンに保存し、必要な場所でだけ `security find-generic-password -a "$USER" -s my-api-key -w` で読み出す。たとえばプロジェクトの direnv 用 `.envrc` や、`~/.zshrc.local` の関数の中で読む。

## 任意のツールとエディタの選択

ツールはどれも必須ではない。シェルは起動時にそれぞれの有無を確かめ、あるときだけエイリアスや連携を設定する。ツールがなければ、元のコマンドがそのまま動く。たとえば `ls` が eza を呼ぶのは、eza がインストールされているときだけだ。各エイリアスの条件は [エイリアス](aliases.md) にある。

| 分野             | ツール                                                          |
| ---------------- | --------------------------------------------------------------- |
| シェルプラグイン | sheldon（なければ `~/.zsh/*.zsh` を直接読み込む）               |
| 履歴、`cd`       | atuin, zoxide, peco, fzf, navi                                  |
| 置き換え         | eza (`ls`), bat (`cat`), dust (`du`), duf (`df`), procs (`ps`), btm (`top`), lazygit (`lg`), colordiff (`diff`) |
| 環境             | mise, direnv, thefuck                                           |
| Git              | delta（ページャ）、Cursor または VS Code（`core.editor`）       |
| エディタ         | Cursor または VS Code（`c`）                                    |

git の設定とエディタの選択だけは例外で、起動時ではなく chezmoi がファイルを生成するときに決まる。git の `core.editor` とシェルのエイリアス `c` は同じエディタを開く。`optin` に `cursor` があり `cursor` コマンドもあれば Cursor（`cursor --wait`）、そうでなく `code` コマンドがあれば VS Code（`code --wait`）を使い、どちらもなければ設定しない。delta、Cursor、VS Code を後から入れたら、もう一度 `chezmoi apply` を実行する。特定のマシンだけ別のエディタにしたいときは、`~/.gitconfig` で `core.editor` を設定し、`~/.zshrc.local` で `c` を定義し直す。

`just doctor` は、上の表のツールのうちどれがインストールされているかを一覧にする。新しいマシンを用意するときは、元のマシンで `brew bundle dump --file=-` を実行し、その一覧から必要なものを入れる。

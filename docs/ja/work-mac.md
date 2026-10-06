# 会社の Mac

ソフトの許可リストがある Mac のためのページ。Oh My Zsh は使えるが sheldon は使えず、
`git clone` は止められ、エディタの拡張機能と Nerd Font も入れられない。この Mac を環境として
定義するものはなく、ほかのマシンと同じく、使えるものに合うスイッチを opt-in する。

## opt-in するもの

| スイッチ         | 動き                                                                                     |
| ---------------- | ---------------------------------------------------------------------------------------- |
| `omz`            | zsh のプラグインを sheldon ではなく、手で `~/.oh-my-zsh` に入れた Oh My Zsh で読み込む。`git` と、このリポジトリに同梱した 3 つ（`~/.zsh/omz-custom` に書かれる）。上下の矢印キーは入力中の文字列で履歴を検索する |
| `cursor`         | Cursor の設定。ほかのマシンと同じ                                                        |
| `editor-builtin` | Cursor（と VS Code）の設定が、Poimandres と catppuccin の拡張、Hack Nerd Font（`editor-extensions`）の代わりに、標準の Default Dark Modern を Poimandres の色に塗り替え、SF Mono、Menlo、Monaco を使う |

`editor-builtin` と `editor-extensions` には既定がない。`cursor` か `vscode` を選んだら、
どちらか一方を必ず選ぶ。

エイリアス、コマンド、プロンプトは、どのマシンでも同じ `~/.zsh/*` のファイル。Oh My Zsh を
入れる前でもシェルは起動する。sheldon のないマシンと同じく、プラグインなしで `~/.zsh/*` を
読み込む。`just doctor` は、どの読み込み方になっているかを表示する。

Oh My Zsh に入っていないプラグインは、apply で clone しなくて済むよう、リリースを固定して
`dot_zsh/omz-custom` に置いている。

| プラグイン                     | バージョン |
| ------------------------------ | ---------- |
| zsh-autosuggestions            | v0.7.1     |
| zsh-syntax-highlighting        | 0.8.0      |
| zsh-history-substring-search   | v1.1.0     |

新しいリリースにするときは、`scripts/vendor-omz-plugins.sh` の固定を書き換え、clone できる
マシンでスクリプトを実行して、結果をコミットする。

## 許可リストとの関係

| ツール                       | 会社の Mac        | dotfiles の動き                                                        |
| ---------------------------- | ----------------- | ---------------------------------------------------------------------- |
| chezmoi                      | 申請予定          | 入るまではこのページの内容はどれも使えない                             |
| Oh My Zsh                    | 許可              | zsh のプラグインを読み込む（`omz`）                                    |
| sheldon                      | 不許可            | `omz` を選んだときは使わない                                           |
| `git clone`                  | 止められる        | apply では何も clone しない（`tmux` スイッチは tpm を clone するので選ばない） |
| fzf、peco、atuin、eza、bat、zoxide、direnv、mise、navi、delta | 今は不許可 | どのエイリアスやキーも、ツールが入っているときだけ設定するので、元のコマンドやキーがそのまま使える（`Ctrl+R` は zsh 標準の履歴検索） |
| Ghostty、Hack Nerd Font      | 不許可            | 使わない。iTerm2 とシステムのフォントを使う                            |
| エディタの拡張機能           | 入れられない      | 色は拡張ではなく設定で付ける（`editor-builtin`）                       |

必要になったツールは IT に申請する。入ってもリポジトリを変える必要はない。git の
ページャ（delta）とエディタの選択だけは、`chezmoi apply` をもう一度実行すると反映される。

## Oh My Zsh を zip から一度だけ入れる

```bash
curl -fsSL -o ~/Downloads/ohmyzsh.zip https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.zip
unzip -q ~/Downloads/ohmyzsh.zip -d ~/Downloads
mv ~/Downloads/ohmyzsh-master ~/.oh-my-zsh
```

Oh My Zsh の `install.sh` は実行しない。`~/.zshrc` を置き換えてしまうが、`~/.zshrc` は
chezmoi が書くもので、`omz` を選べば Oh My Zsh を読み込む。chezmoi は `~/.oh-my-zsh` の
中に何も書かないので、Oh My Zsh の更新はこのディレクトリを新しい zip で置き換えればよい。
Oh My Zsh 自身の更新確認は git を使うので止めてある。

## リポジトリを用意する

このマシンで `chezmoi init` が clone できるなら、それを使う。

```bash
chezmoi init new-marty/chezmoi
```

clone が止められる場合は、リポジトリの zip を chezmoi のソースの場所に置く。あとで更新
するときも、このディレクトリを新しい zip で置き換える。`chezmoi update` は git を使うので
動かない。

```bash
curl -fsSL -o ~/Downloads/chezmoi-src.zip https://github.com/new-marty/chezmoi/archive/refs/heads/main.zip
unzip -q ~/Downloads/chezmoi-src.zip -d ~/Downloads
mkdir -p ~/.local/share
mv ~/Downloads/chezmoi-main ~/.local/share/chezmoi
```

## スイッチを選ぶ

`chezmoi edit-config` で chezmoi の設定を開き、次のように書く。

```toml
[data]
    optin = ["omz", "cursor", "editor-builtin"]
```

## 以前の `~/.dotfiles/` から移る

会社の Mac は zip から作った `~/.dotfiles/` を手で置き、ホームディレクトリから symlink を
張って使っている。chezmoi に移す手順:

1. このマシンのものを、chezmoi が書かないローカルファイルに移す
   （[導入と設定の詳細](setup.md#マシン固有のファイル)を参照）。
   - git: 以前の `~/.gitconfig` にはすべての設定が入っていた。`~/.gitconfig` には
     `user.name`、`user.email` と署名の設定だけを残す。ほかは `~/.config/git/config` から
     来る。git は `~/.gitconfig` を最後に読むので、残した設定は共有の設定より優先される。
   - 秘密の値と追加の `PATH`: `~/.zshenv.local`
   - 自分のエイリアスと関数: `~/.zshrc.local`
2. `~/.dotfiles/` を指す symlink を消す（リンクだけ。ディレクトリはバックアップとして残す）。
   次で一覧できる。

   ```bash
   find ~ ~/.config ~/Library/Application\ Support/Cursor/User -maxdepth 1 -type l -lname "$HOME/.dotfiles/*"
   ```

3. 上の手順でリポジトリを用意し、スイッチを選ぶ。
4. apply で何が書かれるかを確かめる。Cursor の設定は以前の
   `~/.dotfiles/cursor/settings.json` と比べ、残したいものがあれば先にリポジトリへ入れる。

   ```bash
   chezmoi diff
   ```

5. apply する。すでにあるファイルは、書き換える前に確認される。

   ```bash
   chezmoi apply --less-interactive
   ```

6. 新しいターミナルを開き、プロンプト（steeef と時計）、`gst` などのエイリアス、just が
   入っていれば `just --justfile "$(chezmoi source-path)/justfile" doctor` を確かめる。
7. すべて動いたら `~/.dotfiles/` を消す。

## iTerm2 の配色

iTerm2 のプロファイルは chezmoi では管理しないので、手で設定する。プロンプトはこれに
左右されない。トゥルーカラーのターミナル（iTerm2、VS Code と Cursor のターミナル）では、
steeef テーマが Poimandres の色を 16 進で指定する。それ以外の出力の色は、iTerm2 で
Poimandres のカラープリセットを読み込む（Settings → Profiles → Colors → Color Presets →
Import）。色の値は `private_dot_config/ghostty/themes/poimandres.ghostty` にある。

時計は、iTerm2 などでは右側のプロンプトに出る。VS Code と Cursor のターミナルは右側の
プロンプトを表示しないので、そこではプロンプトの 1 行目の最後に出る。

## sheldon や拡張が許可されたら

スイッチはそれぞれ別に変えられる。sheldon は、入れてから一覧の `omz` を外して apply する。
chezmoi は `~/.zsh/omz-custom` を管理しなくなり、ファイルは残るので、これを消し、ほかで
使っていなければ `~/.oh-my-zsh` も消す。エディタの見た目は、Poimandres と catppuccin の拡張、
Hack Nerd Font を入れてから、`editor-builtin` を `editor-extensions` に替えて apply する。

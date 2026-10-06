# 任意のツール

ここに挙げるツールは、どれも入れなくてよい。シェルは起動時にそれぞれの有無を確かめ、入っているものだけエイリアスや連携を設定する。このページには、この dotfiles が各ツールで何をしているかだけを書く。ツール自体の使い方はリンク先を見てほしい。どれが入っているかは `just doctor` で分かる。

## シェル

| ツール | この dotfiles での使い方 |
| ------ | ------------------------ |
| [sheldon](https://sheldon.cli.rs/) | `~/.config/sheldon/plugins.toml` の zsh プラグイン（シンタックスハイライト、入力候補の表示、fzf-tab など）を読み込む。結果は `~/.cache/sheldon.zsh` にキャッシュし、`plugins.toml` が変わると作り直す。sheldon がなければ `~/.zsh/` のファイルだけを読み込む。`omz` スイッチを選ぶと、代わりに Oh My Zsh で読み込む（[導入と設定の詳細](setup.md#sheldon-の代わりに-oh-my-zsh-を使うomz)）。 |
| [fzf](https://junegunn.github.io/fzf/) | `Ctrl+G`、`Ctrl+S`、`Ctrl+F`、`Tab` 補完、`cdf` の一覧に使う。 |
| [peco](https://github.com/peco/peco) | `Ctrl+R` の履歴検索と、`Ctrl+U` の最近いたディレクトリに使う。 |
| [atuin](https://docs.atuin.sh/) | `Ctrl+H` の履歴検索に使う。上矢印キーは zsh のまま。 |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z <パスの一部>` でよく使うディレクトリへ移動する。`zi` は一覧から選ぶ。 |
| [navi](https://github.com/denisidoro/navi) | `Ctrl+N` でチートシートを開く。`navi` スイッチでこのリポジトリのチートシートが入る。 |
| [Neovim](https://neovim.io/) | `nvim` スイッチがヒント用のプラグインと一緒に設定する（[tmux と Vim を覚える](tmux-vim.md)）。 |
| [Google Chrome](https://www.google.com/chrome/) | `just cheatsheet-pdf` がチートシートの印刷に使う。 |
| [thefuck](https://github.com/nvbn/thefuck) | `fuck` で直前のコマンドを直す。 |
| [direnv](https://direnv.net/) | ディレクトリに入ると、その `.envrc` を読み込む。 |
| [mise](https://mise.jdx.dev/) | ディレクトリごとにツールの版を切り替える。`mise` スイッチで全体の既定（Node の LTS、Python 3.12、最新の Go）が入る。 |

## 標準コマンドの置き換え

それぞれエイリアスで標準コマンドを置き換える。[エイリアス](aliases.md#標準コマンドの置き換え)を参照。

| ツール | 置き換えるもの |
| ------ | -------------- |
| [eza](https://eza.rocks/) | `ls` |
| [bat](https://github.com/sharkdp/bat) | `cat` |
| [dust](https://github.com/bootandy/dust) | `du` |
| [duf](https://github.com/muesli/duf) | `df` |
| [procs](https://github.com/dalance/procs) | `ps` |
| [bottom](https://github.com/ClementTsang/bottom)（`btm`） | `top` |
| [colordiff](https://www.colordiff.org/) | `diff` |
| [fd](https://github.com/sharkdp/fd) | `cdf` が使う |

## Git とエディタ

| ツール | この dotfiles での使い方 |
| ------ | ------------------------ |
| [delta](https://dandavison.github.io/delta/) | git のページャ。[Git](git.md#delta) を参照。 |
| [lazygit](https://github.com/jesseduffield/lazygit) | `lg`。 |
| Cursor または VS Code | git の `core.editor` とエイリアス `c`。[導入と設定の詳細](setup.md#エディタの決まり方)を参照。 |

delta、Cursor、VS Code は、シェルの起動時ではなく chezmoi がファイルを書くときに確かめる。どれかを入れたら `chezmoi apply` を実行する。
